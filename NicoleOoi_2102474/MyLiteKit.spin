{
 Project:  MyLiteKit.spin
 Platform: Parallax Project USB Board
 Revision: 1.2
 Author: Nicole Ooi
 Date: 29 November 2021
 Log:
Date: Desc
}
CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

        _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
        _Ms_001 = _ConClkFreq / 1_000

        'config motor control
        motTypeFor   = 1
        motTypeRev   = 2
        motTypeLeft  = 3
        motTypeRight = 4
        motTypeStop  = 5

        'config comm controls
        commForward = 1
        commReverse = 2
        commLeft    = 3
        commRight   = 4
        commStop    = 5


VAR

  long  symbol
  long  mainToF1Val, mainToF2Val, mainUltra1Val, mainUltra2Val

  long motionType

  long decisionMode

OBJ

  'Motors : "Servo8Fast_vZ2.spin"
  Term   : "FullDuplexSerial.spin"
  Motor  : "MotorControl.spin"
  Sensor : "SensorControl.spin"
  CommCtrl : "CommControl.spin"

PUB Main

  Term.Start(31, 30, 0, 115200)

  Sensor.Start(_Ms_001, @mainToF1Val, @mainToF2Val, @mainUltra1Val, @mainUltra2Val)
  Motor.Start
  CommCtrl.Start(_Ms_001, @decisionMode)
  Pause(2000)         'Wait for 2 seconds


  repeat
    Term.Dec(decisionMode)

    case decisionMode
      commForward:
        if(mainUltra1Val > 250 and mainToF1Val < 200)
          Term.Str(String(13, "Move Forward!"))
          Motor.motorMove(commForward)
        else
          Motor.motorMove(commStop)
      commReverse:
        if(mainUltra2Val > 250 and mainToF2Val < 200)
          Term.Str(String(13, "Reverse!"))
          Motor.motorMove(commReverse)
        else
          Motor.motorMove(commStop)

      commLeft:
        if(mainUltra1Val > 250 and mainToF1Val < 200)
          Term.Str(String(13, "Turn Left!!"))
          Motor.motorMove(commLeft)
        else
          Motor.motorMove(commStop)

      commRight:
        if(mainUltra1Val > 250 and mainToF1Val < 200)
          Term.Str(String(13, "Turn Right!!"))
          Motor.motorMove(commRight)
        else
          Motor.motorMove(commStop)

      commStop:
        Term.Str(String(13, "Stop!!"))
        Motor.motorMove(commStop)

PRI Pause(ms) | t

  t := cnt - 1088
  repeat (ms #> 0)
    waitcnt(t += _Ms_001)
  return

DAT
name    byte  "string_data",0