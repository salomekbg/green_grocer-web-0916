def consolidate_cart(cart)
  final = {}
  cart.each {|item_info| item_info.each {|item, info|
      if final.include?(item) == false
        final[item] = info
        final[item][:count] = 1
      else
        final[item][:count] += 1
      end
    }}
  final
end

def apply_coupons(cart, coupons)
  final = cart.clone
  cart.each {|item, data| coupons.each {|coupon|
      if coupon[:item] == item && coupon[:num] <= final[item][:count] && final.keys.include?("#{item} W/COUPON") == false
        final[item][:count] -= coupon[:num]
        final["#{item} W/COUPON"] = {:price => coupon[:cost], :clearance => data[:clearance], :count => 1}
      elsif coupon[:item] == item && coupon[:num] <= final[item][:count] && final.keys.include?("#{item} W/COUPON")
        final[item][:count] -= coupon[:num]
        final["#{item} W/COUPON"][:count] = final["#{item} W/COUPON"][:count] + 1
      end
    }}
   final
end

def apply_clearance(cart)
  cart.each {|item, data| data[:price] -= (data[:price] * 0.20) if data[:clearance]}
  cart
end

def checkout(cart, coupons)
  new_cart = consolidate_cart(cart)
  new_cart = apply_coupons(new_cart, coupons)
  new_cart = apply_clearance(new_cart)
  total = 0
  new_cart.each {|item, data| total += (data[:price] * data[:count])}
  total -= total * 0.10 if total > 100
  total
end
