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

function item_stock(item)
  for slot, item in pairs(barrel.list()) do
    print(item.name)
    print(("%d x %s in slot %d"):format(item.count, item.name, slot))
  end
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
  item_stock(item)
  

end