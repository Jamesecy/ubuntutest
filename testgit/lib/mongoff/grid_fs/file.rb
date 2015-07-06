module Mongoff
  module GridFs
    class File < Mongoff::Record

      include FileFormatter

      def initialize(model, document = nil, new_record = true)
        raise "Illegal file model #{model}" unless model.is_a?(FileModel)
        super
      end

      def chunk_model
        orm_model.chunk_model
      end

      def data
        data = ''
        chunks.sort(n: 1).each { |chunk| data << chunk.data.data }
        data
      end

      def data=(string_or_readable)
        @new_data = string_or_readable
      end

      def save(options = {})
        self[:chunkSize] = FileModel::MINIMUM_CHUNK_SIZE if  self[:chunkSize] < FileModel::MINIMUM_CHUNK_SIZE
        temporary_file = nil
        new_chunks_ids =
          if @new_data
            readable =
              if @new_data.is_a?(String)
                temporary_file = Tempfile.new('file_')
                temporary_file.write(@new_data)
                temporary_file.rewind
                Cenit::Utility::Proxy.new(temporary_file, original_filename: filename)
              else
                @new_data
              end
            if !options[:valid_data] && (file_data_errors = orm_model.data_type.validate_file(readable)).present?
              errors.add(:base, "Invalid file data: #{file_data_errors.to_sentence}")
            else
              create_temporary_chunks(readable)
            end
          end
        temporary_file.close if temporary_file
        if errors.blank? && super
          if new_chunks_ids
            chunks.remove_all
            chunk_model.where(id: {'$in' => new_chunks_ids}).update_all('$set' => {files_id: id})
          end
        end
        errors.blank?
      end

      def destroy
        chunks.remove_all
        super
      end

      private

      def chunks
        chunk_model.where(files: id)
      end

      def create_temporary_chunks(readable)
        new_chunks_ids = []
        temporary_files_id = BSON::ObjectId.new
        md5 = Digest::MD5.new
        length = 0
        n = -1

        reading(readable) do |io|

          self[:filename] = extract_basename(io).squeeze('/') unless self[:filename].present?

          chunking(io, chunkSize) do |buf|
            md5 << buf
            length += buf.size
            chunk = chunk_model.new(temporary_files_id)
            chunk.n = n = n + 1
            chunk.data = BSON::Binary.new(buf, :generic)
            if chunk.save
              new_chunks_ids << chunk.id
            else
              #TODO Handle saving chunk error
              raise Exception.new('fail saving chunks')
            end
          end

          self[:length] ||= length
          self[:uploadDate] ||= Time.now.utc
          self[:md5] ||= md5.hexdigest
        end

        new_chunks_ids
      end

      def reading(arg, &block)
        if arg.respond_to?(:read)
          rewind(arg) do |io|
            block.call(io)
          end
        else
          #TODO Open a file...
          # open(arg.to_s) do |io|
          #   block.call(io)
          # end
        end
      end

      def rewind(io, &block)
        begin
          pos = io.pos
          io.flush
          io.rewind
        rescue
        end

        begin
          block.call(io)
        ensure
          begin
            io.pos = pos
          rescue
          end
        end
      end

      def extract_basename(object)
        file_name =
          if msg = [
            :original_path,
            :original_filename,
            :path,
            :filename,
            :pathname
          ].detect { |msg| object.respond_to?(msg) }
            object.send(msg)
          end
        file_name ? clean(file_name) : nil
      end

      def clean(path)
        basename = ::File.basename(path.to_s)
        CGI.unescape(basename).gsub(%r/[^0-9a-zA-Z_@)(~.-]/, '_').gsub(%r/_+/, '_')
      end

      def chunking(io, chunk_size, &block)
        if io.method(:read).arity == 0
          data = io.read
          i = 0
          loop do
            offset = i * chunk_size
            length = i + chunk_size < data.size ? chunk_size : data.size - offset

            break if offset >= data.size

            buf = data[offset, length]
            block.call(buf)
            i += 1
          end
        else
          while ((buf = io.read(chunk_size)) && buf.size > 0)
            block.call(buf)
          end
        end
      end
    end
  end
end