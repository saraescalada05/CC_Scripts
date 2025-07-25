local monitor = peripheral.find("monitor")
local barrel = peripheral.find("minecraft:barrel")

monitor.setTextScale(0.5)
monitor.setCursorBlink(false)

W,H = monitor.getSize()

ITEM_LIST = {
  {id="exposure:color_film", name="Color film", price=10, currency="silver coins", currency_id="magic_coins:silver_coin"},
  {id="exposure:black_and_white_film", name="B&W film", price=5, currency="silver coins", currency_id="magic_coins:silver_coin"}
}

function monitor_print(text)
  monitor.write(text)
  local x,y = monitor.getCursorPos()
  monitor.setCursorPos(1,y+1)
end

function print_sep(sep)
  if not sep then
    sep = "="
  end
  
  for a = 1,W do
    monitor.write(sep)
  end
  monitor_print()
end

function print_menu()
  monitor.clear()
  monitor.setCursorPos(1,1)
  for i,v in ipairs(ITEM_LIST) do
    monitor_print(v.name)
    monitor_print(v.price .. " " .. v.currency)
    if i ~= #ITEM_LIST then
      print_sep()
    end
  end
end

function menu_selection()
  local event, side, x, y = os.pullEvent("monitor_touch")
  if y%3 ~= 0 then
    local option = math.floor(y/3) + 1
    if option <= #ITEM_LIST then
      return option
    end
  end
  return nil
end

function item_find(item_id)
  for slot, item in pairs(barrel.list()) do
    if item.name == item_id then
      return slot
    end
  end
  return nil
end

function item_stock(item_id)
  local stock = 0
  for slot, item in pairs(barrel.list()) do
    if item.name == item_id then
      stock = stock + item.count
    end
  end
  return stock
end

function first_empty_turtle_slot()
  for i = 1, 16 do
    local current_item = turtle.getItemDetail(i)
    if current_item == nil then
      return i
    end
  end
end

function count_turtle_inventory(item_id)
  local amount
  for i = 1, 16 do
    local current_item = turtle.getItemDetail(i)
    if current_item["name"] == item_id then
      amount = amount + turtle.getItemCount(i)
    end
  end
end

function payment_menu(item,paid)
  monitor.setCursorPos(1,1)
  monitor.clear()
  monitor_print("________________")
  monitor_print("   INTRODUZCA   ")
  monitor_print((item.price - paid) .. " " .. item.currency)
end

function payment(item)
  local amount = item["price"]
  local pay_method = item["currency_id"]
  local paid = 0
  while paid < amount do
    payment_menu(item, paid)
    local fes = first_empty_slot()
    turtle.suck()
    if turtle.getItemDetail(fes)["name"] ~= pay_method then
      error_wrong_payment()
      sleep(2)
      print_menu()
      turtle.dropUp(fes)
    else
      paid = count_turtle_inventory(item["id"])
    end
  end
  return_change(paid,amount)
  congrats_pay_completed()
end

function return_change(paid,amount)
  if paid == amount then
    return false
  end
  wait_for_change()
  local i = 1
  local transfered = 0
  for i = 1, 16 do
    turtle.select(i)
    local slot_count = turtle.getItemCount()
    if slot_count <= amount - transfered then
      barrel.pullItems(peripheral.getName(turtle), i)
      transfered = transfered + slot_count
    elseif slot_count > amount - transfered and amount - transfered ~= 0 then
      barrel.pullItems(peripheral.getName(turtle),i,amount-transfered)
      turtle.dropUp()
    else
      turtle.dropUp()
    end
  end
  return true
end

function drop_item_sold(item_id)
  local slot = item_find(item_id)
  barrel.pushItems(peripheral.getName(turtle),slot,1,1)
  turtle.select(1)
  turtle.dropUp()
end

function error_no_item()
  monitor.setBackgroundColor(colors.red)
  monitor.setCursorPos(1,1)
  monitor.clear()
  monitor_print("-----ERROR:-----")
  monitor_print("    ITEM  NO    ")
  monitor_print("   DISPONIBLE   ")
  monitor_print("       :(       ")
  sleep(2)
  monitor.setBackgroundColor(colors.black)
end

function error_wrong_payment()
  monitor.setBackgroundColor(colors.red)
  monitor.setCursorPos(1,1)
  monitor.clear()
  monitor_print("-----ERROR:-----")
  monitor_print("     METODO     ")
  monitor_print("    DE  PAGO    ")
  monitor_print("    INVALIDO    ")
  monitor_print("       :(       ")
  sleep(2)
  monitor.setBackgroundColor(colors.black)
end

function wait_for_change()
  monitor.setCursorPos(1,1)
  monitor.clear()
  monitor_print("   POR FAVOR,   ")
  monitor_print("     ESPERE     ")
  monitor_print("   SU  CAMBIO   ")
end

function congrats_pay_completed()
  monitor.setBackgroundColor(colors.green)
  monitor.setCursorPos(1,1)
  monitor.clear()
  monitor_print("  ENHORABUENA!  ")
  monitor_print(" HAS COMPLETADO ")
  monitor_print("    EL  PAGO    ")
  monitor_print("       :)       ")
  sleep(3)
  monitor.setBackgroundColor(colors.black)
end

while true do
  print_menu()
  local option = nil
  repeat
    option = menu_selection()
  until (option~=nil)
  local item = ITEM_LIST[option]
  local stock = item_stock(item["id"])

  print(stock)

  if stock == 0 then
    error_no_item()
  else
    payment(item)
    drop_item_sold(item["id"])
  end
end