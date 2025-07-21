local monitor = peripheral.find("monitor")

monitor.setTextScale(0.5)
monitor.setCursorBlink(false)

W,H = monitor.getSize()

ITEM_LIST = {
  {id="exposure:color_film",name="Color film", price=10},
  {id="exposure:black_and_white_film",name="BnW film", price=5}
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
    monitor_print("Precio: " .. v.price)
    if i ~= #ITEM_LIST then
      print_sep()
    end
  end
end

function find_item(id)
  for i = 1, 16 do
    if turtle.getItemDetail(i)["name"] == id then
      return i
    end
  end
  return 0
end

while true do
  print_menu()
  local event, side, x, y = os.pullEvent("monitor_touch")
  if y%3 ~= 0 then
    local option = math.floor(y/3) + 1
    local pos = find_item(ITEM_LIST[option]["id"])
    if pos ~= 0 then
      turtle.select(pos)
      turtle.dropUp(1)
    else
      monitor.setBackgroundColor(colors.red)
      monitor.setCursorPos(1,1)
      monitor_print("ERROR")
      monitor_print("No queda :(")
      sleep(2)
      monitor.setBackgroundColor(colors.black)
    end
  end
end