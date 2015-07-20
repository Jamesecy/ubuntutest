module Spree
  module Wombat
    module Handler
      class UpdateOrderHandler < Base

        def process
          order_hsh = @payload[:order]

          order_number = order_hsh.delete(:id)
          if order = Spree::Order.where(number: order_number).first
            msg = nil

            if order_hsh[:shipping_status] == 'shipped'
              order.shipments.each do |shipment|
                if shipment.ready?
                  #mark shipment as shipped
                  shipment.ship!

                  #add tracking number
                  if order_hsh.key? :tracking_number
                    shipment.update_attribute(:tracking, order_hsh[:tracking_number])
                  end

                  msg = "Shipment has been marked as shipped."
                end
              end
            end

            msg ||= 'Order update was processed'
            return response(msg)
          else
            return response("Unabled to find order #{order_number}", 500)
          end


        end

      end
    end
  end
end
