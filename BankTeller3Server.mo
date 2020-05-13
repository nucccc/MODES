model BankTeller3Server
MODES.EventsLib.Blocks.Generator Entrance(distributionParameter1 = 4, distributionSelected = 0, localSeed = 7)  annotation(
     Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
   MODES.EventsLib.Blocks.Queue Queue(outputsNumber = 3)  annotation(
     Placement(visible = true, transformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
MODES.EventsLib.Blocks.Server BankTeller1(distributionParameter1 = 10, distributionSelected = 0)  "server" annotation(
     Placement(visible = true, transformation(origin = {20, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
MODES.EventsLib.Blocks.Displacer Exit(inputsNumber = 3)  annotation(
     Placement(visible = true, transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
MODES.EventsLib.Blocks.Server BankTeller2(distributionParameter1 = 10, distributionSelected = 0) annotation(
     Placement(visible = true, transformation(origin = {20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
MODES.EventsLib.Blocks.Server BankTeller3(distributionParameter1 = 10, distributionSelected = 0) annotation(
     Placement(visible = true, transformation(origin = {20, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
connect(Queue.OUT[3], BankTeller3.IN[1]) annotation(
     Line(points = {{-10, 3.55271e-16}, {-6, 3.55271e-16}, {-6, 3.55271e-16}, {0, 3.55271e-16}, {0, -26}, {10, -26}, {10, -26}, {10, -26}, {10, -26}}, thickness = 0.5));
connect(BankTeller3.OUT[1], Exit.IN[3]) annotation(
     Line(points = {{30, -26}, {34, -26}, {34, -26}, {40, -26}, {40, 0}, {50, 0}, {50, 0}, {50, 0}, {50, 0}}, thickness = 0.5));
connect(Queue.OUT[2], BankTeller2.IN[1]) annotation(
     Line(points = {{-10, 3.55271e-16}, {0, 3.55271e-16}, {0, 3.55271e-16}, {10, 3.55271e-16}, {10, 3.55271e-16}, {9, 3.55271e-16}, {9, 3.55271e-16}, {10, 3.55271e-16}}, thickness = 0.5));
connect(BankTeller2.OUT[1], Exit.IN[2]) annotation(
     Line(points = {{30, 3.55271e-16}, {40, 3.55271e-16}, {40, 5.29396e-24}, {50, 5.29396e-24}, {50, 3.55271e-16}, {50, 3.55271e-16}, {50, 3.55271e-16}, {50, 3.55271e-16}}, thickness = 0.5));
connect(BankTeller1.OUT[1], Exit.IN[1]) annotation(
     Line(points = {{30, 26}, {40, 26}, {40, 0}, {50, 0}}, thickness = 0.5));
connect(Queue.OUT[1], BankTeller1.IN[1]) annotation(
     Line(points = {{-10, 3.55271e-16}, {-5, 3.55271e-16}, {-5, 3.55271e-16}, {0, 3.55271e-16}, {0, 26}, {4, 26}, {4, 26}, {10, 26}}, thickness = 0.5));
connect(Entrance.OUT[1], Queue.IN[1]) annotation(
     Line(points = {{-50, 3.55271e-16}, {-41, 3.55271e-16}, {-41, 4.44089e-16}, {-32, 4.44089e-16}, {-32, 4.44089e-16}, {-32, 4.44089e-16}, {-32, 3.55271e-16}, {-30, 3.55271e-16}}, thickness = 0.5));

    annotation(
      experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-6, Interval = 0.2),
      __OpenModelica_simulationFlags(lv = "LOG_EVENTS_V", s = "dassl"));
end BankTeller3Server;