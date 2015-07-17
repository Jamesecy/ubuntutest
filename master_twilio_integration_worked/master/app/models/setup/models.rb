module Setup
  class Models
    class << self
      include Enumerable

      def unregist(model)
        @models ||= Hash.new { |h, k| h[k] = [] }
        @models.delete(model)
      end

      def regist(model)
        @models ||= Hash.new { |h, k| h[k] = [] }
        @models[model]
      end

      def [](model)
        @models ||= Hash.new { |h, k| h[k] = [] }
        @models[model]
      end

      def count
        @models ? @models.count : 0
      end

      def each(&block)
        @models.each(&block) if @models
      end

      def exclude_actions_for(model, *actions)
        @models[model] += actions
      end

      def excluded_actions_for(model)
        @models[model]
      end

      def registered?(model)
        @models.include?(model)
      end
    end
  end
end
