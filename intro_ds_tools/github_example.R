for (i in 0:222) {
  
  print(paste0(i, " - 1", " = ", i-1))
  
  if (i == 222) {
    print('Hello World!')
  }
  
  Sys.sleep(.25)
  
}