model BankTeller1Server
MODES.EventsLib.Blocks.Generator Entrance(distributionParameter1 = 0.25, distributionParameter2 = 0.35, distributionSelected = 1, localSeed = 7)  annotation(
      Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    MODES.EventsLib.Blocks.Queue Queue(outputsNumber = 1)  annotation(
      Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 MODES.EventsLib.Blocks.Server BankTeller1(distributionParameter1 = 10, distributionSelected = 0, outputsNumber = 0)  "server" annotation(
      Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(Queue.OUT[1], BankTeller1.IN[1]) annotation(
    Line(points = {{10, 0}, {30, 0}}, thickness = 0.5));
  connect(Entrance.OUT[1], Queue.IN[1]) annotation(
    Line(points = {{-30, 0}, {-12, 0}, {-12, 0}, {-10, 0}}, thickness = 0.5));
  annotation(
      experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-6, Interval = 0.2),
      __OpenModelica_simulationFlags(lv = "LOG_EVENTS_V", s = "dassl"));
end BankTeller1Server;