def consolidate_cart(cart)
  final_cart = Hash.new
  cart.each do |item|
    item.each do |name, val|
      if final_cart.has_key?(name)
        final_cart[name][:count] += 1
      else
        final_cart[name] = val
        final_cart[name][:count] = 1
      end
    end
  end
  final_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    val = coupon[:item]
     if cart[val] && cart[val][:count] >= coupon[:num]
         if cart ["#{val} W/COUPON"]
         cart["#{val} W/COUPON"][:count] += 1
     else
       cart["#{val} W/COUPON"] = {count: 1, price: coupon[:cost]}
       cart["#{val} W/COUPON"][:clearance] = cart[val][:clearance]
     end
     cart[val][:count] -= coupon[:num]
   end
 end
cart
end

def apply_clearance(cart)
  cart.each do |name, val|
    val[:price] = (0.8 * val[:price]).round(2) if val[:clearance]
  end
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  use_coupons = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(use_coupons)
  total = 0
  final_cart.each do |name, val|
    total += val[:price] * val[:count]
  end
  return total > 100 ? total * 0.9 : total
end
