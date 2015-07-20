#hack for values needed for demo
class DemoShipmentSerializer < Spree::Wombat::ShipmentSerializer
  attributes :shipping_method, :shipping_carrier, :order_total, :created_at

  def shipping_carrier
    "UPS"
  end

  def order_total
    object.order.total.to_f
  end
end
