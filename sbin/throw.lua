--throw program
--like a system panic, no kernel panic stuff

term.clear()
term.setCursorPos(1,1)
print(" !!! DAWN THROW !!! ")
print("A program has called this to reboot the system.")
print("The system will restart in 3 seconds.")
sleep(3)
os.reboot()