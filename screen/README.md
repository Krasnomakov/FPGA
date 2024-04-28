![Alt text](https://drive.google.com/file/d/17m6StBCx-BkY2VH-ZPn8EpSyansv2WSS/view?usp=sharing "Title")
1. **Module Declaration and Parameters**:
   - We're making a thing called `screen`.
   - It needs a setting called `STARTUP_WAIT` to know how long to wait.

2. **Input and Output Ports**:
   - It listens to a clock (a signal that ticks regularly), and it can talk back using signals called `io_sclk`, `io_sdin`, etc.

3. **Initialization and Constants**:
   - We have different states like "starting up" or "sending data."
   - We've got some internal counters and flags to keep track of what's happening.

4. **Setting Up the Screen**:
   - We have a list of commands to send to the screen when it starts up, like "turn off display" or "set screen brightness."

5. **Sending Commands and Data**:
   - We send these commands one by one to set up the screen properly.
   - Once set up, we start sending actual picture data to display.

6. **Updating the Screen**:
   - We keep track of time and which pixel we're sending.
   - We send each pixel's color information to the screen.

7. **Loading Image Data**:
   - We've got a file called "image.hex" that contains the picture data.
   - We read this file and store the image data internally.

8. **Clock Cycle Behavior**:
   - Depending on what state we're in, we do different things each time the clock ticks.
