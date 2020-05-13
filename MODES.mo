package MODES
	annotation(
    Documentation(info = "<HTML>
    
    <p>MODES (MOdelica Discrete Event Systems) is a Modelica library designed to run discrete events simulations in OpenModelica environment. It is composed by the following subpackages:
    <ul>
    <li><b>Atomic_PKG</b>: package containing the Atomic block from which to start creating DEVS atomic models.</li>
    <li><b>Template_PKG</b>: providing a starting point to extend the Atomic partial block from <b>Atomic_PKG</b>.</li>
    <li><b>EventsLib</b>: a library to perform discrete event simulations with blocks based on the parallel DEVS formalism.</li>
    </ul>
    Additionally, in this distribution the following packages can be found:
    <ul>
    <li><b>I40Lab</b>: package containing blocks to simulate the plant installed in I4.0 Lab, an activity present in the thesis work describing this library.</li>
    <li><b>ServerExample_PKG</b>: a package in which a basic Server block is defined, used as an example in the thesis work describing this library, at chapter 3.1.3.</li>
    </ul>
    </p>
    
    <p>To simulate discrete event systems it resorts to the Parallel DEVS formalism, invented by Bernard P. Ziegler.<br>
    To simulate parallel DEVS atomic models this package divides the transition procedure in 5 event iteration steps.
    
    <ol>
		<li>Detect internal events, when internal transitions are scheduled to happen. </li>
		<li>Send and detect messages as external events. </li>
		<li>Acquire the messages content and decide for every atomic models which transition shall be executed. </li>
		<li>Execute the transition, updating the state. </li>
		<li>Schedule new internal events based on new state </li>
    </ol>
    
    Below a Petri Net showing the five steps procedure can be seen.
    
    </p>
    
    <img width=\"500\" src=\"modelica://MODES/Resources/Images/Petri-1.png\">

</HTML>"));

	package Atomic_PKG
		annotation(
    Documentation(info = "<HTML>
    
    <p>This package contains components that can be used to define Parallel Atomic DEVS models:
<ul>
<li>3 records that define the variables that can be extended to characterize the DEVS:

<ul>
  <li><b>State</b>: containing state variables, is updated at transitions.</li>
  <li><b>InputVariables_X</b>: Input variables, used to store informations from external events, to be used by external transitions. Representative of the <i>Bag</i> from parallel DEVS specification.</li>
  <li><b>OutputVariables_Y</b>: To be updated before every internal event, its variables represent the result of the lambda output function on the given state.</li>
</ul>
<br>
<li>A parial block called <b>Atomic</b>, containing records instanciations and variables used to handle transiotions. Can be extended to model atomic DEVS.
</ul>
    
    
<p>
<h3><font color=\"#008000\">State</font></h3>
Aimed at containing state variables, should be updated only by transitions.<br>
</p>

<p>
<h3><font color=\"#008000\">InputVariables_X</font></h3>
Aimed at containing informations coming from input ports after every external event.<br>
Can be used in the transition execution algorithm section for external and confluent transitions to update the state.<br>

<p>
<h3><font color=\"#008000\">OutputVariables_Y</font></h3>
Aimed at containing output informations generated using state variables.<br>
Has to be updated right before every internal event triggers a transition.<br>
</p>

</HTML>"));
		
		record State
			
		end State;
		
		record InputVariables_X
			
		end InputVariables_X;
		
		record OutputVariables_Y
			
		end OutputVariables_Y;
		
		
		
		partial block Atomic
		
			annotation(
    Documentation(info = "<HTML>
    
   <p>This partial block is aimed at managing the transition triggers to run parallel DEVS simulations.<br>
   To achieve that it contains the following elements:
   
   <ul>
<li>3 replaceable record declarations that define the parallel DEVS' variables. In extending DEVS blocks they can be redeclared to be substitued with the proper records representing the desired atomic model.

<ul>
  <li> A State instantiation <b>S</b>: containing state variables, can be updated by inheriting parallel DEVS blocks at transitions using an algorithm in the form:<br>
  
  <pre><i>when pre(confluent_transtion) then
	//S.some_variable := S.some_variable + some_variable; 
elsewhen pre(external_transition) then 
	//S.some_variable := S.some_variable + some_variable; 
elsewhen pre(internal_transition) then
	//S.some_variable := S.some_variable + some_variable; 
end when; </i></pre>
  
  </li>
  <li> An InputVariables_X instantiation <b>X</b>: input variables, used to store informations from external events, to be used by external transitions. Representative of the <i>Bag</i> from parallel DEVS specification. Shall be updated by extending DEVS blocks using input connectors' values inside a pre(), by an algorithm in the form:

<pre><i>when pre(external_event) then
	//X.some_variable := pre(CONNECTOR.some_variable); 
end when; </i></pre>

  </li>
  <li> An OutputVariables_Y instantiation <b>Y</b>: to be updated before every internal event, its variables represent the result of the lambda output function on the given state. Its values should be updated using state variables before every internal or confluent transition is triggered, by an algorithm section in the form:

<pre><i>when pre(internal_transition_planned[1]) then
	//Y.some_variable := S.some_variable; 
end when; </i></pre>

  </li>
</ul>
<br>
<li>A set of boolean variables managed by the <b>Atomic</b> partial block, used to trigger transitions:

	<ul>
	 <li><b>internal_transition</b></li>
	 <li><b>external_transition</b></li>
	 <li><b>confluent_transition</b></li>
	</ul>
</li>

<li>A variable <b>next_TS</b>, which stand for next Scheduled Transition, that is used to set the time instant of the next internal event. Should be updated in inheriting DEVS blocks, by an algorithm section representing for <i>ta(s)</i> functions from DEVS specification formalism:

<pre><i>when pre(transition_happened) then
	//next_TS := S.some_variable; 
end when; </i></pre>

</li>

<li> A boolean <b>internal_event</b> equal to <i>time > <b>next_TS</b></i>, used to trigger the beginning of an event chain leading to an internal or a confluent transtion.
</li>

<li> A boolean array <b>external_event[:]</b> with undefined size,  shall be redeclared in all extending DEVS blocks with a dimension suitable for the number of possible external events that may happen. Its members should be assigned so as to be triggered right when an external event happens, so that the DEVS block is advised of the presence of an external event and will behave consequently.
</li>

<li> Two protected undeclared integer parameters <b>n_inputs</b> and <b>n_outputs</b> that by default can be used to account for the number of input and output ports of the system.
</li>
A real variable <b>elapsed_time</b> that can be used in external and confluent transitions to determine the new state.
</li>

</ul>
 
<p>


</HTML>"));
		
			replaceable State S;
			replaceable InputVariables_X X;
			replaceable OutputVariables_Y Y;
			discrete Real next_TS "Variable defining the time instant of the next internal transition";
			discrete Real last_transition_time (start = 0) "accounting for the time instant of last transtion";
			Real elapsed_time = time - last_transition_time "amount of time elapsed since last transition";
			Boolean transition_happened = pre(confluent_transition) or pre(external_transition) or pre(internal_transition) "boolean that uses S.transition_number to account for the happening of a transition";
			//set of variables representing the number of transition happened
			//for every possible kind of transition
			//have no use in system's modeling, are just left for simulation evaluation
			Integer n_of_internal_transitions_happened(start = 0);
			Integer n_of_external_transitions_happened(start = 0);
			Integer n_of_confluent_transitions_happened(start = 0);
		protected
			parameter Integer n_inputs;
			parameter Integer n_outputs;
			Boolean internal_event = time > next_TS;
			Boolean external_event[:] "Array to be redeclared in every block, used to catch changes in external variables and so to acknowledge the arrival of an external event";
			Boolean internal_transition (start = false) "Boolean used to trigger internal state transitions";
			Boolean external_transition (start = false) "Boolean used to trigger external state transitions";
			Boolean confluent_transition (start = false) "Boolean used to trigger confluent state transitions";
			Boolean internal_transition_planned[2] (start = {false, false}) "Booleans used to plan internal transitions: whenever an internal event happens the first if gets flagged. The second is set to be the pre() of the first, so that internal transitions are retarded, thus being simultaneous to external ones";
			Boolean external_transition_planned (start = false) "When an external event happens this boolean is flagged to track that an external transition needs to be triggered, confluent if an internal event is happening at the same time";
		algorithm
			when pre(transition_happened) then
				last_transition_time := time;
			end when;
		algorithm
			when cat(1, {change(next_TS), internal_event, pre(internal_transition_planned[1])}, external_event) then //Whenever an event happens or there was an internal event at the previous time step this when is entered
				if pre(internal_transition_planned[1]) then
					internal_transition_planned[2] := true "At first, if the internal event was at the previous time step update the second flag";
				elseif internal_event then
					internal_transition_planned[1] := true "Otherwise, in case of internal event, fire the first flag";
				end if;
				if max(external_event) then
					external_transition_planned := true "In presence of an external event";
				end if;
				internal_transition := false;
				external_transition := false;
				confluent_transition := false "In case an event is triggered but a transition occurred at the previous iteration step, set to false all transition triggers";
			elsewhen not max(external_event) and (pre(internal_transition_planned[2]) or pre(external_transition_planned)) then //When no events are arriving and transitions are schedeled this when is entered
				if external_transition_planned and internal_transition_planned[2] then
					confluent_transition := true "in case both an internal and an external event happened use the confluent transition";
				elseif external_transition_planned then
					external_transition := true;
				elseif internal_transition_planned[2] then
					internal_transition := true;
				end if "An if else tree decides which transition should be triggered";
				internal_transition_planned := {false, false};
				external_transition_planned := false "At the end, all transition planning variables are put to false";
			elsewhen pre(internal_transition) or pre(external_transition) or pre(confluent_transition) then
				internal_transition := false;
				external_transition := false;
				confluent_transition := false "In case nothing happened, but at the previous step there has been a transition, reset the triggers";
			end when;
		algorithm
			//algorithm aimed at updating the number of transition happened of every possible kind
			when pre(confluent_transition) then
				n_of_confluent_transitions_happened := n_of_confluent_transitions_happened + 1;
			elsewhen pre(external_transition) then
				n_of_external_transitions_happened := n_of_external_transitions_happened + 1;
			elsewhen pre(internal_transition) then
				n_of_internal_transitions_happened := n_of_internal_transitions_happened + 1;
			end when;
		end Atomic;
		
	end Atomic_PKG;
	
	
	
	package Template_PKG
	
	annotation(
    Documentation(info = "<HTML>
    
	Starting block from which is possible to start to define new atomic blocks.

</HTML>"));
	
		record StateTmp
			extends Atomic_PKG.State;
		end StateTmp;
		
		record InputVariables_XTmp
			extends Atomic_PKG.InputVariables_X;
		end InputVariables_XTmp;
		
		record OutputVariables_YTmp
			extends Atomic_PKG.OutputVariables_Y;
		end OutputVariables_YTmp;
		
		
		
		block Template
			extends Atomic_PKG.Atomic(redeclare StateTmp S, redeclare InputVariables_XTmp X, redeclare OutputVariables_YTmp Y, n_inputs = number_inputs, n_outputs = number_outputs, redeclare Boolean external_event[n_external_events]);
			parameter Integer n_external_events = 1 "example number used to express the dimension of redeclared external_event array";
			parameter Integer number_inputs;
			parameter Integer number_outputs;
		initial algorithm
		//INITIALIZATION PHASE FOR VARIABLES
		algorithm
		//UPDATING next_TS
			when pre(transition_happened) then
				//next_TS := S.value;
			end when;
		algorithm
			when pre(internal_transition_planned[1]) then
				//Y.value := S.value;
			end when;
		///////////////////////////////////////////////////////////////////////
		//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
		///////////////////////////////////////////////////////////////////////
		//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables
		algorithm
			when pre(external_event) then
				for i in 1:n_outputs loop
					//X.input_value := pre(CONNECTOR.input_value);
				end for;
			end when;
		///////////////////////////////////////////////////////////////////////
		//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
		///////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		//                        TRANSITIONS CODE                           //
		///////////////////////////////////////////////////////////////////////
		algorithm		
			when pre(confluent_transition) then
			//CONFLUENT TRANSITION CODE
				//S.state_variable := S.state_variable + 1 "Updating the number of transitions";
				
			elsewhen pre(external_transition) then
			//EXTERNAL TRANSITION CODE
				//S.state_variable := S.state_variable + 1 "Updating the number of transitions";
				
			elsewhen pre(internal_transition) then
			//INTERNAL TRANSITION CODE
				//S.state_variable := S.state_variable + 1 "Updating the number of transitions";
				
			end when;
		///////////////////////////////////////////////////////////////////////
		//                     END OF TRANSITIONS CODE                       //
		///////////////////////////////////////////////////////////////////////	
		equation
			for i in 1:n_external_events loop
				//external_event[i] = change(CONNECTOR.input_value);
				//CONNECTOR.ouput_value = Y.value;
			end for;
		end Template;
	  
	end Template_PKG;
	
	
	
	package EventsLib
	
	annotation(
    Documentation(info = "<HTML>
    
    <p>EventsLib is a package providing blocks to perform discrete events simulation. Its functionalities are inspired by the SimEvents library, provided in the SIMULINK environment.<br>
All the active blocks are developed starting from the Atomic partial block, and they have been modeled and designed following the DEVS specification formalism.<br>
The basic unit that is transmitted from one block to the other is the event, which can represent discrete uniform entities or other components flowing inside the system, depending on the needs of the user. Every augmentation of value 1 in the blocks’ connectors indicates that an event
moves from output to input port. An augmentation with value <i>n</i> corresponds
the transfer of <i>n</i> events from output to input port.
A block can have multiple input and output ports, but all the possible connections
must be one-to-one. The following subpackages can be found:
    <ul>
    <li><b>Blocks</b>: a package containing the library's blocks.</li>
    <li><b>Interfaces</b>: package containing the two connectors used as ports by the blocks.</li>
    <li><b>Functions</b>.</li>
    <li><b>RNG</b>: package containing a block for performing random number generation.</li>
    <li><b>BlocksPackages</b>: packae containg DEVS blocks source code.</li>
    </ul>
    </p>
    

</HTML>"));
	
		package Blocks
		
			block Generator = BlocksPackages.Generator_PKG.Generator;
			block Queue = BlocksPackages.Queue_PKG.Queue;
			block Server = BlocksPackages.Server_PKG.Server;
			block Delay = BlocksPackages.Delay_PKG.Delay;
			block RandomSwitch = BlocksPackages.RandomSwitch_PKG.RandomSwitch;
			block Combiner = BlocksPackages.Combiner_PKG.Combiner;
			block Displacer = BlocksPackages.Displacer_PKG.Displacer;
			
			package AuxiliaryBlocks			
				annotation(
    Documentation(info = "<HTML>
    
	<b>AuxiliaryBlocks</b><br>
<br>
A set of auxiliary blocks is provided to eventually manage connections between components. Even though many blocks provide for multiple connections, the user can choose to pick a block to merge a pair of ports or other simple operations. They are not modeled following the DEVS formalism, thus they do not require any event iteration step to accomplish their operations, mantaining the DEVS synchronized.

<ul>
<li> <b>EventMultiplier</b>: takes events from input and output and multiplies by a constant. If we desire a block to output an event from its first port and concurrently two events out of the second port, an EventMultiplier can be placed at the end of this last port to multiply its output.<br>
The user can also choose to multiply the request value.
</li><li> <b>EventDuplicate</b>: for every event received transmits an event through both its two output ports. The user if the request value the input will set is going the minimum or maximum of the two output ports.
</li><li> <b>EventSum</b>: acquires events from two input ports and redirects them through one input port by summing them. The request value from the output ports is directly propagated at its input ports.
</ul>


</HTML>"));
			
				block EventMultiplier "Block that multiplies the events from input to output by a parameter"
					EventsLib.Interfaces.In_Port IN annotation(
			          Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
					EventsLib.Interfaces.Out_Port OUT annotation(
			          Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
					parameter Integer event_multiplier = 1;
					parameter Integer request_multiplier = 1;
				algorithm
					when change(IN.event_signal) then
						OUT.event_signal := IN.event_signal * event_multiplier;
					end when;
					when change(OUT.event_request_signal) then
						IN.event_request_signal := OUT.event_request_signal * request_multiplier;
					end when;
				end EventMultiplier;			
				
				block EventDuplicate "Block that duplicates the events received in input tp its two output ports"
					EventsLib.Interfaces.In_Port IN annotation(
			          Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
					EventsLib.Interfaces.Out_Port OUT1 annotation(
			          Placement(visible = true, transformation(origin = {100, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, 45}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
			        EventsLib.Interfaces.Out_Port OUT2 annotation(
			          Placement(visible = true, transformation(origin = {100, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, -45}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
					parameter Boolean max_request = true "if true, request given in input is the maximum of the two, otherwise the min";
				algorithm
					when change(IN.event_signal) then
						OUT1.event_signal := IN.event_signal;
						OUT2.event_signal := IN.event_signal;
					end when;
					when {change(OUT1.event_request_signal), change(OUT2.event_request_signal)} then
						if max_request then
							IN.event_request_signal := max(OUT1.event_request_signal, OUT2.event_request_signal);
						else
							IN.event_request_signal := min(OUT1.event_request_signal, OUT2.event_request_signal);
						end if;
					end when;
				end EventDuplicate;
				
				block EventSum "Block that sums events coming from multiple inputs to one output"
					EventsLib.Interfaces.In_Port IN1 annotation(
			          Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, -45}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
			        EventsLib.Interfaces.In_Port IN2 annotation(
			          Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 45}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
					EventsLib.Interfaces.Out_Port OUT annotation(
			          Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
				algorithm
					when {change(IN1.event_signal), change(IN1.event_signal)} then
						OUT.event_signal := IN1.event_signal + IN2.event_signal;				
					end when;
					when change(OUT.event_request_signal) then
						IN1.event_request_signal := OUT.event_request_signal;
						IN2.event_request_signal := OUT.event_request_signal;
					end when;
				end EventSum;
				
			end AuxiliaryBlocks;
		  
		end Blocks;
	
		package Interfaces
		  
			connector In_Port
				input Integer event_signal "Event arrival signal";
				output Integer event_request_signal "Channel to let the block require events";
				annotation(
      Icon(graphics = {Rectangle(origin = {0, -1}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 101}, {100, -99}}), Line(origin = {4.49296, -0.303664}, points = {{-35.6464, 72}, {36.3536, 0}, {-35.6464, -72}, {-35.6464, -72}}, color = {0, 0, 255}, thickness = 3)}, coordinateSystem(initialScale = 0.1)));
			end In_Port;

			connector Out_Port
				output Integer event_signal "Signal used to send signals";
				input Integer event_request_signal "Events communicated from blocks connected in output";
				annotation(
      Icon(graphics = {Rectangle(origin = {0, -1}, fillPattern = FillPattern.Solid, extent = {{-100, 101}, {100, -99}}, fillColor = {0, 0, 255}), Line(origin = {4.49296, -0.303664}, points = {{-35.6464, 72}, {36.3536, 0}, {-35.6464, -72}, {-35.6464, -72}}, color = {255, 255, 255}, thickness = 3)}));
			end Out_Port;
		  
		end Interfaces;
		
		package Functions
	
			function ImmediateInternalTransition "function used to decrement next internal transition time to trigger consecutive internal transitions"
				input Real next_TS_in;
				output Real next_TS_out;
			algorithm
				if next_TS_in >= 0 then
					next_TS_out := -1;
				else
					next_TS_out := next_TS_in - 1;
				end if;
			end ImmediateInternalTransition;

		end Functions;
		
			package RNG
		
			block RandomGenerator
				annotation(
    Documentation(info = "<HTML>
    
   	In this block, the implementation of the Xorshift1024* algorithm contained in the Modelica Standard Library is used to generate random numbers for selecting statuses lifetimes.\par
Its operations have been wrapped inside a block named <b>RandomGenerator</b>, that uses this generator to obtain uniform and exponential distributions for different models. Blocks entitled to follow stochastic behaviour have these parameters to select the desired behaviour:

<ul>
<li> <b>localSeed</b> and <b>globalSeed</b> are the seeds employed to generate the RNG's state, and will have to be set by the user.
</li><li> <b>distributionSelected</b> is an integer that can be used to select the desired distribution. A constant distribution is related to the value 0, uniform distribution to value 1, exponential distribution to value 2 and a gaussian to value 3. If another integer is set, by default the constant distribution is selected.
</li><li> <b>distributionParameter1</b> and <b>distributionParameter2</b> are the parameters used to characterize the distribution.\\
In case constant distribution is chosen, the block will deterministically return <b>distributionParameter1</b>, otherwise the distributions will take the following forms:

<ul>
<li>
Uniform: <b>U</b>(a, b)
</li>
<li>
Exponential: <b>E</b>(<i>lambda</i> = a)
</li>
<li>
Gaussiam: <b>N</b>(<i>mu</i> = a, <i>sigma</i> = b)
</li>

with
<li>
a = <b>distributionParameter1</b>, b = <b>distributionParameter2</b>
</li>
</ul>

In case a constant distribution is required and <b>distributionParameter1</b> < <b>distributionParameter2</b> the numbers generated will be constant and equal to <b>distributionParameter1</b>.</li>
</ul>


</HTML>"));
				parameter Integer localSeed = 10 "localSeed of the RNG";
				parameter Integer globalSeed = 7 "globalSeed of the RNG";
				parameter Integer distributionSelected = 0 "0 = constant; 1 = uniform; 2 = exponential";
				parameter Real distributionParameter1 = 1;
				parameter Real distributionParameter2 = 0 "used only in uniform distrib";
				discrete Real randomValue;
				input Integer trigger;
				Boolean number_request = change(trigger);
				parameter Real lower_limit = 0.00001;
			protected
				Integer RNGState[33];
			initial algorithm
				RNGState := Modelica.Math.Random.Generators.Xorshift1024star.initialState(localSeed, globalSeed);
				if distributionSelected == 1 then
					(randomValue, RNGState) := Modelica.Math.Random.Generators.Xorshift1024star.random(RNGState);
					randomValue := distributionParameter1 + randomValue * max(0, distributionParameter2 - distributionParameter1);
				elseif distributionSelected == 2 then
					(randomValue, RNGState) := Modelica.Math.Random.Generators.Xorshift1024star.random(RNGState);
					randomValue := -Modelica.Math.log(randomValue) / distributionParameter1;
				elseif distributionSelected == 3 then
					(randomValue, RNGState) := Modelica.Math.Random.Generators.Xorshift1024star.random(RNGState);
					randomValue := Modelica.Math.Distributions.Normal.quantile(randomValue, distributionParameter1, distributionParameter2);
				else	
					randomValue := distributionParameter1;
				end if;
				if randomValue < lower_limit then
					randomValue := lower_limit;
				end if;
			algorithm
				when pre(number_request) then
					if distributionSelected == 1 then
					(randomValue, RNGState) := Modelica.Math.Random.Generators.Xorshift1024star.random(RNGState);
					randomValue := distributionParameter1 + randomValue * max(0, distributionParameter2 - distributionParameter1);
				elseif distributionSelected == 2 then
					(randomValue, RNGState) := Modelica.Math.Random.Generators.Xorshift1024star.random(RNGState);
					randomValue := -Modelica.Math.log(randomValue) / distributionParameter1;
				elseif distributionSelected == 3 then
					(randomValue, RNGState) := Modelica.Math.Random.Generators.Xorshift1024star.random(RNGState);
					randomValue := Modelica.Math.Distributions.Normal.quantile(randomValue, distributionParameter1, distributionParameter2);
				else	
					randomValue := distributionParameter1;
				end if;
				if randomValue < lower_limit then
					randomValue := lower_limit;
				end if;
				end when;
			end RandomGenerator;
		  
		end RNG;
	
		
		package BlocksPackages "Containing packages models' records and implementation blocks"
		
			/////////////////////////////////////////////////////////////////////////
			//						GENERATOR PACKAGE							//
			/////////////////////////////////////////////////////////////////////////
			package Generator_PKG
			
				record StateGen
					extends Atomic_PKG.State;
					discrete Real next_TS "Effective time instant of next internal transition";
					discrete Real next_scheduled_generation "Since next_TS is affected by blocking of ports, this variable stores the completion time instant";
					Integer events_already_sent "Events that the block had already sent through its output ports";
					Boolean blocked_output "true when OUT.event_request_signal differs from zero, thus output is blocked";
					Integer events_in_batch "Events belonging to the last generated batch still to be sent";
					Integer events_being_sent "Events that are going to be sent at the next internal event";
					Boolean immediate_transition_required "boolean set to true everytime that the next status will have 0 lifetime";
				end StateGen;
				
				record InputVariables_XGen
					extends Atomic_PKG.InputVariables_X;
					parameter Integer n_outputs;
					Boolean portBlocked[n_outputs] "Array that stores information about blockage of output ports (an output port is considered blocked when its request value -1)";
				end InputVariables_XGen;
				
				record OutputVariables_YGen
					extends Atomic_PKG.OutputVariables_Y;
					Integer eventsSent "Elements generated in output";
				end OutputVariables_YGen;
				
				
				
				block Generator
					annotation(
    Documentation(info = "<HTML>
    
	<b>Generator</b><br>
<br>
This block cyclically introduces events in the system. It is possible to send multiple batches of events simultaneously by using more than one output port.<br>
In case any of its ports happen to be blocked, it continues to prepare the generation, but doesn't send events once generated. In case a port is blocked and unlocked between two generation time instants, no visible effect can be seen in the inputs and outputs of the block.<br>
It starts a new generation only once all the already generated events have been successfully sent.<br>
To tune it, it is possible to act on its random distribution for selecting the timeadvance and the following parameters:

<ul>
<li> <b>outputBatchDimension</b>: amount of events that are going to be created at every new generation.
</li><li> <b>sendEventsSingularly</b>: if true, batches of events will be sent one by one, to let the receiver some transition steps to close its ports if necessary. If the system being modeled has no serious constraints on capacity, this parameter can be set to false so that all generated events will be sent together in the space of a unique transition. Having less transitions to inspect can be more convenient when simulation events are analyzed.
</li><li> <b>generateOnStart</b> can be used to determine if the first event generation will happen at the beginning of the simulation or after a certain amount of time.
</ul>

</HTML>"));
					extends Atomic_PKG.Atomic(redeclare StateGen S, redeclare InputVariables_XGen X(n_outputs = n_outputs), redeclare OutputVariables_YGen Y, n_inputs = inputsNumber, n_outputs = outputsNumber, redeclare Boolean external_event[n_outputs]);
					parameter Integer outputBatchDimension = 1 "Elements produced at every generation";
					constant Integer inputsNumber = 0 "number of input ports of the system";
					parameter Integer outputsNumber = 1 "number of output ports of the system";
					//Random number generation components
					RNG.RandomGenerator RNGBlock(localSeed = localSeed, globalSeed = globalSeed, distributionSelected = distributionSelected, distributionParameter1 = distributionParameter1, distributionParameter2 = distributionParameter2);
					parameter Integer localSeed = 10 "localSeed of the RNG";
					parameter Integer globalSeed = 7 "globalSeed of the RNG";
					parameter Integer distributionSelected = 0 "0 = constant; 1 = uniform; 2 = exponential";
					parameter Real distributionParameter1 = 1;
					parameter Real distributionParameter2 = 0 "used only in uniform distribution to set the bias of the random number";
					parameter Boolean sendEventsSingularly = true "if true, events ready to be sent are sent in a unique batch, otherwise multiple sendings are executed for all the available events. In case the block at the end has a certain capacity, it is advised to keep this value true to avoid events being discarded. Otherwise, if no such strictness is required, transmissions of batches of events can be activated by setting to false this parameters. Calculation performances would increase";
					parameter Boolean generateOnStart = true "if true an element will be generated at the start of the generation, otherwise a time cycle will occur before the first output propagation";
					//Block's ports
					EventsLib.Interfaces.Out_Port OUT[n_outputs] annotation(
		          Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
				initial algorithm
					if generateOnStart then
						S.next_scheduled_generation := 0 "in case a generation on start is required the next internal transtion will happen at zero time";
					else
						S.next_scheduled_generation := RNGBlock.randomValue "otherwise the next internal transition will happen around a certain time instant given by the random number generator";
						RNGBlock.trigger := RNGBlock.trigger + 1 "augmenting the RNG trigger to require the generation of a new random number";						
					end if ;
					S.next_TS := S.next_scheduled_generation;
					S.events_already_sent := 0 "The generator starts with an element already produced";
					if sendEventsSingularly then
						S.events_in_batch := outputBatchDimension - 1;
						S.events_being_sent := 1;
					else
						S.events_in_batch := 0;
						S.events_being_sent := outputBatchDimension;
					end if "prepare the first sending";
					S.blocked_output := false "by default the output ports are considered open";
					for i in 1:n_outputs loop
						X.portBlocked[i] := pre(OUT[i].event_request_signal) == -1;
					end for;
					Y.eventsSent := 0;
					next_TS := S.next_TS;
				algorithm
				//UPDATING next_TS
					when pre(transition_happened) then
						next_TS := S.next_TS "After every transition next_TS equals the value set into the state";
					end when;
				algorithm
					when pre(internal_transition_planned[1]) then
						Y.eventsSent := S.events_already_sent + S.events_being_sent "At transition time the number of outputs sent is equal to the value of events already sent plus the events set at this new lambda output. The transition will thus update the state number of elements already sent";
					end when;
					/*elsewhen internal_transition_planned[2] then
						for i in 1:n_outputs loop
							OUT[i].event_signal := Y.eventsSent;
						end for;
					end when;*/
				///////////////////////////////////////////////////////////////////////
				//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
				///////////////////////////////////////////////////////////////////////
				//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables
				algorithm
					when pre(external_event) then
						for i in 1:n_outputs loop
							X.portBlocked[i] := pre(OUT[i].event_request_signal) == -1 "If the output port's request value is -1, the port is considered blocked";
						end for;
					end when;
				///////////////////////////////////////////////////////////////////////
				//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
				///////////////////////////////////////////////////////////////////////
				///////////////////////////////////////////////////////////////////////
				//                        TRANSITIONS CODE                           //
				///////////////////////////////////////////////////////////////////////
				algorithm		
					when pre(confluent_transition) then
					//CONFLUENT TRANSITION CODE
						
						S.blocked_output := false "At the beginning of every transition it is assumed that the output is not blocked, to then check for every port";
						for i in 1:n_outputs loop
							if X.portBlocked[i] then
								S.blocked_output := true "If any port is found blocked the whole system considers the output blocked"; 
							end if;
						end for "loop aimed at checking if any of the output ports is considered blocked"; 
						S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
						if S.events_being_sent > 0 then
							S.events_already_sent := S.events_already_sent + S.events_being_sent "if an event had been sent during the last transition, add it to the already sent events";
							if S.events_in_batch > 0 then
								S.events_being_sent := 0;
								if not S.blocked_output then
									S.immediate_transition_required := true "if an event has been sent but there are still and the ports are open schedule a transition with no outputs";
								end if;
							else //if no other events are left to be sent, schedule a new generation
								S.next_scheduled_generation := time + RNGBlock.randomValue "when a new generation is started, the next internal event is scheduled to be in advance by an amount of time set by the RNG";
								RNGBlock.trigger := RNGBlock.trigger + 1 "augmenting the RNG trigger to require the generation of a new random number";
								if sendEventsSingularly then
									S.events_in_batch := outputBatchDimension - 1;
									S.events_being_sent := 1;
								else
									S.events_in_batch := 0;
									S.events_being_sent := outputBatchDimension;
								end if "if events have to be sent one by one, send one, otherwise send entire batch";
							end if "if there are still events left to send, schedule an idle transition, otherwise start a new generation";	
						else //if no events have been sent before this transition
							if S.events_in_batch > 0 then
								if not S.blocked_output then
									S.immediate_transition_required := true "if the last transition did not output anything, there are still elements to be sent and the outputs are open, send immediately an event";
									if sendEventsSingularly then
										S.events_in_batch := S.events_in_batch - 1;
										S.events_being_sent := 1;
									else
										S.events_being_sent := S.events_in_batch;
										S.events_in_batch := 0 ;								
									end if "if events have to be sent one by one, send one, otherwise send entire batch";
								end if;
							else //if no events have been sent but the batch is somehow empty, schedule a new generation. This case is almost impossible, but still it is treated
								S.next_scheduled_generation := time + RNGBlock.randomValue "next generation is scheduled at a timedvance in advance to the actual time";
								RNGBlock.trigger := RNGBlock.trigger + 1 "augmenting the RNG trigger to require the generation of a new random number";
								if sendEventsSingularly then
									S.events_in_batch := outputBatchDimension - 1;
									S.events_being_sent := 1;
								else
									S.events_in_batch := 0;
									S.events_being_sent := outputBatchDimension;
								end if "if events have to be sent one by one, send one, otherwise send entire batch";
							end if;	
						end if "if branch used to decide what to do right after an internal event depending on the events sent";
						
						if S.blocked_output then
							S.next_TS := Modelica.Constants.inf "until output is blocked next transition is scheduled at infinite time";
						elseif S.immediate_transition_required then
							S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
						else
							S.next_TS := S.next_scheduled_generation "otherwise the next internal event will be when normally scheduled";
						end if;
						
					elsewhen pre(external_transition) then
					//EXTERNAL TRANSITION CODE
						
						S.blocked_output := false "At the beginning of every transition it is assumed that the output is not blocked, to then check for every port"; 
						for i in 1:n_outputs loop
							if X.portBlocked[i] then
								S.blocked_output := true "If any port is found blocked the whole system considers the output blocked"; 
							end if;
						end for "loop aimed at checking if any of the output ports is considered blocked";
						S.immediate_transition_required := false "for safety, immediate transition is always set false at the beginning of a transition";
						if S.blocked_output then
							S.next_TS := Modelica.Constants.inf "until output is blocked next transition is scheduled at infinite time";
						elseif S.immediate_transition_required then
							S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
						else
							S.next_TS := S.next_scheduled_generation "otherwise the next internal event will be when normally scheduled";
						end if "if any of the output ports are blocked, then the next internal transition is set to infinite, otherwise, it is just the next scheduled one";
					elsewhen pre(internal_transition) then
					//INTERNAL TRANSITION CODE
						
						S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
						if S.events_being_sent > 0 then
							S.events_already_sent := S.events_already_sent + S.events_being_sent "if an event had been sent during the last transition, add it to the already sent events";
							if S.events_in_batch > 0 then
								S.events_being_sent := 0;
								if not S.blocked_output then
									S.immediate_transition_required := true "if an event has been sent but there are still and the ports are open schedule a transition with no outputs";
								end if;
							else
								S.next_scheduled_generation := time + RNGBlock.randomValue "when a new generation is started, the next internal event is scheduled to be in advance by an amount of time set by the RNG";
								RNGBlock.trigger := RNGBlock.trigger + 1 "augmenting the RNG trigger to require the generation of a new random number";
								if sendEventsSingularly then
									S.events_in_batch := outputBatchDimension - 1;
									S.events_being_sent := 1;
								else
									S.events_in_batch := 0;
									S.events_being_sent := outputBatchDimension;
								end if "if events have to be sent one by one, send one, otherwise send entire batch";
							end if "if there are still events left to send, schedule an idle transition, otherwise start a new generation";	
						else
							if S.events_in_batch > 0 then
								if not S.blocked_output then
									S.immediate_transition_required := true "if the last transition did not output anything, there are still elements to be sent and the outputs are open, send immediately an event";
									if sendEventsSingularly then
										S.events_in_batch := S.events_in_batch - 1;
										S.events_being_sent := 1;
									else
										S.events_being_sent := S.events_in_batch;
										S.events_in_batch := 0;								
									end if "if events have to be sent one by one, send one, otherwise send entire batch";
								end if;
							else //if no events have been sent but the batch is somehow empty, schedule a new generation. This case is almost impossible, but still it is treated
								S.next_scheduled_generation := time + RNGBlock.randomValue "when a new generation is started, the next internal event is scheduled to be in advance by an amount of time set by the RNG";
								RNGBlock.trigger := RNGBlock.trigger + 1 "augmenting the RNG trigger to require the generation of a new random number";
								if sendEventsSingularly then
									S.events_in_batch := outputBatchDimension - 1;
									S.events_being_sent := 1;
								else
									S.events_in_batch := 0;
									S.events_being_sent := outputBatchDimension;
								end if "if events have to be sent one by one, send one, otherwise send entire batch";
							end if;	
						end if;
						
						if S.blocked_output then
							S.next_TS := Modelica.Constants.inf "until output is blocked next transition is scheduled at infinite time";
						elseif S.immediate_transition_required then
							S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
						else
							S.next_TS := S.next_scheduled_generation "otherwise the next internal event will be when normally scheduled";
						end if;
					
					end when;
				///////////////////////////////////////////////////////////////////////
				//                     END OF TRANSITIONS CODE                       //
				///////////////////////////////////////////////////////////////////////	
				equation
					for i in 1:n_outputs loop
						OUT[i].event_signal = Y.eventsSent;
						external_event[i] = change(OUT[i].event_request_signal);
					end for;
				end Generator;
			  
			end Generator_PKG;
			/////////////////////////////////////////////////////////////////////////
			//						END OF GENERATOR PACKAGE						//
			/////////////////////////////////////////////////////////////////////////
			
			
			
			/////////////////////////////////////////////////////////////////////////
			//							QUEUE PACKAGE							//
			/////////////////////////////////////////////////////////////////////////
			package Queue_PKG
			
				record StateQue
					extends Atomic_PKG.State;
					parameter Integer n_inputs;
					parameter Integer n_outputs;
					Boolean immediate_transition_required "boolean set to true everytime that the next status will have 0 lifetime";
					discrete Real next_TS "time instant of next internal transition";
					Integer events_in_queue "number of elements in queue";
					Integer acquired_events[n_inputs] "value of elements arrived at the last transition from input ports";
					Integer events_sent[n_outputs] "elements to be sent out of output ports";
					Integer requests_acquired[n_outputs] "value of requests arrived at the last transition from input ports";
					Integer pending_requests[n_outputs] "requests awaiting to be satisfied for every input port";
					Boolean blocking_input_ports "If true then the queue reached maximum capacity and so input ports need to be blocked";
					Integer eventsDiscarded "amount of events arrived that could not be retained because of capacity issues and that will be discarded from the system";
				end StateQue;
				
				record InputVariables_XQue
					extends Atomic_PKG.InputVariables_X;
					parameter Integer n_inputs;
					parameter Integer n_outputs;
					Integer eventsArrived[n_inputs] "number of elements arrived in input";
					Integer requestsArrived[n_outputs] "number of requests arrived from outputs";
				end InputVariables_XQue;
				
				record OutputVariables_YQue
					extends Atomic_PKG.OutputVariables_Y;
					parameter Integer n_outputs;
					Integer eventsSent[n_outputs] "elements sent as output to requesting blocks";
					Integer inputPortsRequestValue "Value used to eventually block input ports";
				end OutputVariables_YQue;
				
				block Queue
					annotation(
    Documentation(info = "<HTML>
    
	<b>Queue</b><br>
<br>
A queue receives events from inputs and stores them. At the same time, it receives requests from server blocks through its output ports, and will send events to the querying port if it has enough of them stored to satisfy the request. The priority with which requests will be satisfied is given by the index of the connector.<br>
The maximum amount of events that a queue can be stored can be defined by its capacity. If a queue has a set of pending requests, it will first satisfy them with the events arrived, and only after will check if the storing limit has been reached. In case, it blocks its output ports. Its behaviour can be defined with the following parameters.

<ul>
<li> <b>capacity</b> defines the maximum amount of events that the queue is supposed to store. If no unlimited capacity is desired, this value can be set to -1.
</li><li> <b>fragmentedService</b> allows to choose between two policies for pending requests satisfaction. If true, the queue is allowed to partially satisfy pending requests. For example, if a server required two events, when an event arrives it is directly sent to that server, even if it doesn't satisfy completely the request.<br>
When false, a queue will satisfy a pending request only if it has enough events to serve it entirely.
</li><li> <b>allowEventsInExcess</b> can be used to specify whether or not events surpassing the capacity limit will be kept or discarded.
</li><li> <b>startingEventsInQueue</b> specifies the amount of events which the queue initially possesses, usually 0.
</ul>

</HTML>"));
					extends Atomic_PKG.Atomic(redeclare StateQue S(n_inputs = n_inputs, n_outputs = n_outputs), redeclare OutputVariables_YQue Y(n_outputs = n_outputs), redeclare InputVariables_XQue X(n_inputs = n_inputs, n_outputs = n_outputs), n_inputs = inputsNumber, redeclare Boolean external_event[n_inputs + n_outputs], n_outputs = outputsNumber);
					parameter Integer inputsNumber = 1 "number of input ports of the system";
					parameter Integer outputsNumber = 1 "number of output ports of the system";			
					parameter Integer capacity = -1;
					parameter Boolean fragmentedService = false "Fragmented service true: pending requests with more than one element may be partially served; false: pending requests will be satisfied only when whole pending request will be satisfiable";
					parameter Boolean allowEventsInExcess = true "If true, when elements surpassing the capacity arrive, they are retained if less than the twice the number of inputs. If false, elements in excess are discarded";
					parameter Integer startingEventsInQueue = 0 "number of elements in the queue at the beginning of the simulation";
					EventsLib.Interfaces.In_Port IN[n_inputs] annotation(
			         Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
					EventsLib.Interfaces.Out_Port OUT[n_outputs] annotation(
			         Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
				initial algorithm
					S.events_in_queue := startingEventsInQueue;
					for i in 1:n_inputs loop
						S.acquired_events[i] := 0;
					end for;
					S.next_TS := Modelica.Constants.inf "At start no internal transition is scheduled";
					S.blocking_input_ports := S.events_in_queue >= capacity and capacity >= 0;
					S.immediate_transition_required := S.blocking_input_ports;
					for i in 1:n_outputs loop
						S.pending_requests[i] := 0;
						S.requests_acquired[i] := 0;
						S.events_sent[i] := 0;
						X.requestsArrived[i] := 0;
						Y.eventsSent[i] := S.events_sent[i];
					end for;
					for i in 1:n_inputs loop
						X.eventsArrived[i] := 0;
					end for;
					if S.blocking_input_ports then
						Y.inputPortsRequestValue := -1;
					else
						Y.inputPortsRequestValue := 0;
					end if;
					next_TS := S.next_TS;
				algorithm
				//UPDATING next_TS
					when pre(transition_happened) then
						next_TS := S.next_TS "After every transition next_TS equals the value set into the state";
					end when;
				algorithm
					when pre(internal_transition_planned[1]) then
						for i in 1:n_outputs loop
							Y.eventsSent[i] := S.events_sent[i];
						end for;
						if S.blocking_input_ports then
							Y.inputPortsRequestValue := -1;
						else
							Y.inputPortsRequestValue := 0;
						end if "If input ports are set ot be blocked then request value is set to -1, otherwise 0";
					end when;
				///////////////////////////////////////////////////////////////////////
				//                        TRANSITIONS CODE                           //
				///////////////////////////////////////////////////////////////////////
				algorithm
					when pre(confluent_transition) then
					//CONFLUENT TRANSITION CODE
					//After an external event a queue has to: 1. check if new elements have arrived and add them to the queue 2. check if new requests arrived and memorize the as pending requests 3. check if elements can be sent to satisfy requests 4. set the output ports in relation to capacity and check if an internal transition to transmit outputs has to be fired
						
						for i in 1:n_inputs loop
							S.events_in_queue := S.events_in_queue + X.eventsArrived[i] - S.acquired_events[i]"update the number of elements in the queue considering the difference between actual and previous inputs";					
							S.acquired_events[i] := X.eventsArrived[i] "at the next transition the previous inputs will be equal to the actual ones";
						end for "Cicle aimed at updating the events_in_queue value";
						for i in 1:n_outputs loop
							if X.requestsArrived[i] - S.requests_acquired[i] > 0 then
								S.pending_requests[i] := S.pending_requests[i] + X.requestsArrived[i] - S.requests_acquired[i] "number of previous requests is updated according to the difference between actual and previous requests";
								S.requests_acquired[i] := X.requestsArrived[i] "at the next transition the previous requests will be equal to the actual ones";
							end if;
						end for "Cicle aimed at updating the pending_requests";
						S.immediate_transition_required := false "At the beginning of requests evaluations we assume no response is needed";
						for i in 1:n_outputs loop //check requests from every output port
							if S.pending_requests[i] > 0 then //in case a pending request from port i is present
								if S.events_in_queue >= S.pending_requests[i] then
									S.events_sent[i] := S.events_sent[i] + S.pending_requests[i] "elements sent at output i is augmented enough to satisfy the request";
									S.events_in_queue := S.events_in_queue - S.pending_requests[i] "elements are effectively prelevated from the queue";
									S.pending_requests[i] := 0 "No more requests are left pending after satisfaction";
									S.immediate_transition_required := true "we flag that we will need an internal transition to output the elements to be sent";
								elseif fragmentedService and S.events_in_queue > 0 then //In case the queue doesn't have enough elements to satisfy the request, in case of unitary service the request is fulfilled partially
									S.events_sent[i] := S.events_sent[i] + S.events_in_queue "All elements in the queue are sent in output";
									S.pending_requests[i] := S.pending_requests[i] - S.events_in_queue "the pending request is reduced by the number of elements the queue contained";
									S.events_in_queue := 0 "the queue is emptied";
									S.immediate_transition_required := true "we flag that we will need an internal transition";
								end if;
							end if;
						end for;
						
						if S.events_in_queue > capacity and capacity > -1 and not allowEventsInExcess then
							S.eventsDiscarded := S.eventsDiscarded + S.events_in_queue - capacity;
							S.events_in_queue := capacity;
						end if "If the queue has a certain capacity, after having satisfied requests, events in excess are removed";
						if capacity > -1 and S.events_in_queue >= capacity and not S.blocking_input_ports then //In case the queue contains more elements than allowed and the input ports are not blocked, then block them immediately by setting immediate_transition_required to true
							S.blocking_input_ports := true;
							S.immediate_transition_required := true;
						elseif S.events_in_queue < capacity and S.blocking_input_ports then //In case the port was locked but there is room for elements, unlock the inputs immediately by setting immediate_transition_required to true
							S.blocking_input_ports := false;
							S.immediate_transition_required := true;
						end if "if branch used to handle the blocking of input ports";
						if S.immediate_transition_required then
							S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "In case the queue has to send elements or inputs need to blocked, next internal transition needs to be immediate";
						else
							S.next_TS := Modelica.Constants.inf "in case no elements need to be sent and ports are unlocked, the queue becomes passive and sets to infity its next internal event";
						end if;
					elsewhen pre(external_transition) then
					//EXTERNAL TRANSITION CODE
					//After an external event a queue has to: 1. check if new elements have arrived and add them to the queue 2. check if new requests arrived and memorize the as pending requests 3. check if elements can be sent to satisfy requests 4. set the output ports in relation to capacity and check if an internal transition to transmit outputs has to be fired
						
						for i in 1:n_inputs loop
							S.events_in_queue := S.events_in_queue + X.eventsArrived[i] - S.acquired_events[i]"update the number of elements in the queue considering the difference between actual and previous inputs";					
							S.acquired_events[i] := X.eventsArrived[i] "at the next transition the previous inputs will be equal to the actual ones";
						end for "Cicle aimed at updating the events_in_queue value";
						for i in 1:n_outputs loop
							if X.requestsArrived[i] - S.requests_acquired[i] > 0 then
								S.pending_requests[i] := S.pending_requests[i] + X.requestsArrived[i] - S.requests_acquired[i] "number of previous requests is updated according to the difference between actual and previous requests";
								S.requests_acquired[i] := X.requestsArrived[i] "at the next transition the previous requests will be equal to the actual ones";
							end if;
						end for "Cicle aimed at updating the pending_requests";
						S.immediate_transition_required := false "At the beginning of requests evaluations we assume no response is needed";
						for i in 1:n_outputs loop //check requests from every output port
							if S.pending_requests[i] > 0 then //in case a pending request from port i is present
								if S.events_in_queue >= S.pending_requests[i] then
									S.events_sent[i] := S.events_sent[i] + S.pending_requests[i] "elements sent at output i is augmented enough to satisfy the request";
									S.events_in_queue := S.events_in_queue - S.pending_requests[i] "elements are effectively prelevated from the queue";
									S.pending_requests[i] := 0 "No more requests are left pending after satisfaction";
									S.immediate_transition_required := true "we flag that we will need an internal transition to output the elements to be sent";
								elseif fragmentedService and S.events_in_queue > 0 then //In case the queue doesn't have enough elements to satisfy the request, in case of unitary service the request is fulfilled partially
									S.events_sent[i] := S.events_sent[i] + S.events_in_queue "All elements in the queue are sent in output";
									S.pending_requests[i] := S.pending_requests[i] - S.events_in_queue "the pending request is reduced by the number of elements the queue contained";
									S.events_in_queue := 0 "the queue is emptied";
									S.immediate_transition_required := true "we flag that we will need an internal transition";
								end if;
							end if;
						end for;

						if S.events_in_queue > capacity and capacity > -1 and not allowEventsInExcess then
							S.eventsDiscarded := S.eventsDiscarded + S.events_in_queue - capacity;
							S.events_in_queue := capacity;
						end if "If the queue has a certain capacity, after having satisfied requests, elements in excess are removed";
						if capacity > -1 and S.events_in_queue >= capacity and not S.blocking_input_ports then //In case the queue contains more elements than allowed and the input ports are not blocked, then block them immediately by setting immediate_transition_required to true
							S.blocking_input_ports := true;
							S.immediate_transition_required := true;
						elseif S.events_in_queue < capacity and S.blocking_input_ports then //In case the port was locked but there is room for elements, unlock the inputs immediately by setting immediate_transition_required to true
							S.blocking_input_ports := false;
							S.immediate_transition_required := true;
						end if "if branch used to handle the blocking of input ports";
						if S.immediate_transition_required then
							S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "In case the queue has to send elements or inputs need to blocked, next internal transition needs to be immediate";
						else
							S.next_TS := Modelica.Constants.inf "in case no elements need to be sent and ports are unlocked, the queue becomes passive and sets to infity its next internal event";
						end if;
					elsewhen pre(internal_transition) then
					//INTERNAL TRANSITION CODE
					//After an internal transition the queue goes into passive state, awaiting for external events
						
						S.next_TS := Modelica.Constants.inf;
						S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
					end when;
				///////////////////////////////////////////////////////////////////////
				//                     END OF TRANSITIONS CODE                       //
				///////////////////////////////////////////////////////////////////////
				///////////////////////////////////////////////////////////////////////
				//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
				///////////////////////////////////////////////////////////////////////
				//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables	
				algorithm
					when pre(external_event) then
						for i in 1:n_inputs loop					
							X.eventsArrived[i] := pre(IN[i].event_signal);
						end for;
						for i in 1:n_outputs loop
							X.requestsArrived[i] := pre(OUT[i].event_request_signal);
						end for;
					end when;
				///////////////////////////////////////////////////////////////////////
				//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
				///////////////////////////////////////////////////////////////////////
				equation
					for i in 1:n_inputs loop
						external_event[i] = change(IN[i].event_signal);
						IN[i].event_request_signal = Y.inputPortsRequestValue;
					end for;
					for i in 1:n_outputs loop
						OUT[i].event_signal = Y.eventsSent[i];
						external_event[n_inputs + i] = change(OUT[i].event_request_signal);
					end for;
				end Queue;
			  
			end Queue_PKG;
			/////////////////////////////////////////////////////////////////////////
			//							END OF QUEUE PACKAGE						//
			/////////////////////////////////////////////////////////////////////////
			
			
			
			/////////////////////////////////////////////////////////////////////////
			//							SERVER PACKAGE							//
			/////////////////////////////////////////////////////////////////////////
			package Server_PKG
			  
				record StateSer
					extends Atomic_PKG.State;
					parameter Integer n_inputs;
					discrete Real next_TS "time of next scheduled internal transition";
					Integer events_processed "Elements successfully processed by the server";			
					Integer request "Requests sent by the server";			
					Boolean active "true if the server is precessing events or not";
					Integer events_acquired[n_inputs] "number of overall events acquired at input ports, effectively they are input events at the end of the previous transition";
					Integer events_in_buffer "number of events currently ready to be processed but not being actually processed. Used to store events if request is served partially";
					discrete Real next_scheduled_generation "Since next_TS is affected by blocking of ports, this variable stores the real completion time instant";
					Boolean blocked_output "true when IN.event_request_signal differs from zero, thus output is blocked";
					Integer events_already_sent "Events that the block had already sent through its output ports";
					Integer events_in_batch "Events belonging to the last generated batch still to be sent";
					Integer events_being_sent "Events that are going to be sent at the next internal event";
					Boolean immediate_transition_required "boolean set to true everytime that the next status will have 0 lifetime";
				end StateSer;
				
				record InputVariables_XSer
					extends Atomic_PKG.InputVariables_X;
					parameter Integer n_inputs;
					parameter Integer n_outputs;
					Integer eventsArrived[n_inputs] "Events arrived from input ports";
					Boolean portBlocked[n_outputs] "Array that stores information about blockage of output ports (an output port is considered blocked when its request value -1)";
				end InputVariables_XSer;
				
				record OutputVariables_YSer
					extends Atomic_PKG.OutputVariables_Y;
					Integer eventsSent "Events sent in output by the server";
					Integer request "requests for events emitted by the server";
				end OutputVariables_YSer;
				
				block Server
					annotation(
    Documentation(info = "<HTML>
    
	<b>Server</b><br>
<br>
A server block queries for new events and then processes them taking up some time. Once an  batch of events is processed, it queries for new events and sends the ones it has just completed. A new job won't start until all the processed events have been successfully sent.<br>
All arriving events are collected and conserved, so practically it is possible to connect a server directly to the output of a generator or another block, which will ignore the server's requests and will transmit events at its own rate.<br>
To restrict the amount of requests to only one queried block, a server is allowed to have only one input port, but multiple batches of events can be simultaneosly sent through its outport ports if desired. If any of the output ports is blocked, the server keeps the job active but doesn't send events when completed. The following parameters can be used to set its behaviour, together with the parameters used to define the time required to complete its process:

<ul>
<li> <b>outputBatchDimension</b> is the amount of events generated after every process is finished.
</li><li> <b>requestDimension</b> is the amount of required events to begin a process.
</li><li> <b>sendEventsSingularly</b> if true batches of events will be sent one by one, to let the receiver some transition steps to close its ports if necessary. If the system being modeled has no serious constraints on capacity, this parameter can be set to false so that all events will be sent together in the space of a unique transition. Having less transitions to inspect can be more convenient when simulation events are analyzed.
</ul>


</HTML>"));
					extends Atomic_PKG.Atomic(redeclare StateSer S(n_inputs = n_inputs), redeclare OutputVariables_YSer Y, redeclare InputVariables_XSer X(n_inputs = n_inputs, n_outputs = n_outputs), n_inputs = inputsNumber, redeclare Boolean external_event[n_inputs + n_outputs], n_outputs = outputsNumber);
					parameter Integer outputBatchDimension = 1 "Events given at output once process is finished";
					parameter Integer requestDimension = 1 "Events required to start process";
					constant Integer inputsNumber = 1 "number of input ports of the system";
					parameter Integer outputsNumber = 1 "number of output ports of the system";
					//Random number generation components
					RNG.RandomGenerator RNGBlock(localSeed = localSeed, globalSeed = globalSeed, distributionSelected = distributionSelected, distributionParameter1 = distributionParameter1, distributionParameter2 = distributionParameter2);
					parameter Integer localSeed = 10 "localSeed of the RNG";
					parameter Integer globalSeed = 7 "globalSeed of the RNG";
					parameter Integer distributionSelected = 0 "0 = constant; 1 = uniform; 2 = exponential";
					parameter Real distributionParameter1 = 1;
					parameter Real distributionParameter2 = 0 "used only in uniform distribution to set the bias of the random number";
					parameter Boolean sendEventsSingularly = true "if true, events ready to be sent are sent in a unique batch, otherwise multiple sendings are executed for all the available events. In case the block at the end has a certain capacity, it is advised to keep this value true to avoid events being discarded. Otherwise, if no such strictness is required, transmissions of batches of events can be activated by setting to false this parameters. Calculation performances would increase";
					//Block's ports
					EventsLib.Interfaces.In_Port IN[n_inputs] annotation(
		          Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
					EventsLib.Interfaces.Out_Port OUT[n_outputs] annotation(
		          Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
				initial algorithm
					S.next_scheduled_generation := Modelica.Constants.inf;
					S.next_TS := 0 "the next internal transition is scheduled at time 0 to send a request";
					S.request := requestDimension "the beginning request to be sent is equal to the amount of entities required to start a process";
					S.active := false "server starts idle";
					for i in 1:n_inputs loop
						S.events_acquired[i] := 0 "no events are acquired at the beginning of the process";
					end for;
					S.events_processed := 0 "server starts with no elements processed";
					S.events_in_buffer := 0 "no elements ready to be processed at the beginning";
					Y.eventsSent := 0;
					Y.request := 0;
					for i in 1:n_inputs loop
						X.eventsArrived[i] := pre(IN[i].event_signal);
					end for;
					for i in 1:n_outputs loop
						X.portBlocked[i] := pre(OUT[i].event_request_signal) == -1;
					end for;
					S.blocked_output := false; 
					for i in 1:n_outputs loop
						if X.portBlocked[i] then
							S.blocked_output := true; 
						end if;
					end for;
					next_TS := S.next_TS;
				algorithm
				//UPDATING next_TS
					when pre(transition_happened) then
						next_TS := S.next_TS "After every transition next_TS equals the value set into the state";
					end when;
				algorithm
					when pre(internal_transition_planned[1]) then 
						Y.eventsSent := S.events_already_sent + S.events_being_sent "At transition time the number of outputs sent is equal to the value of events already sent plus the events set at this new lambda output. The transition will thus update the state number of elements already sent";
						Y.request := S.request "output requests as required by the state";
					end when;
				///////////////////////////////////////////////////////////////////////
				//                        TRANSITIONS CODE                           //
				///////////////////////////////////////////////////////////////////////
				algorithm
					when pre(confluent_transition) then
					//CONFLUENT TRANSITION CODE
						S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
						
						S.blocked_output := false "At the beginning of every transition it is assumed that the output is not blocked, to then check for every port"; 
						for i in 1:n_outputs loop
							if X.portBlocked[i] then
								S.blocked_output := true "If any port is found blocked the whole system considers the output blocked"; 
							end if;
						end for "loop aimed at checking if any of the output ports is considered blocked";
						
						for i in 1:n_inputs loop
							S.events_in_buffer := S.events_in_buffer + X.eventsArrived[i] - S.events_acquired[i] "number of events ready to be processed are updated by the difference between actual and previous inputs";
							S.events_acquired[i] := X.eventsArrived[i] "at the next transition previous input elements will be equal to the actual ones";
						end for "for loop to acquire arrived events";	
						
						if S.active then
							S.active := false "if server was active after an internal event it needs to be deactivated";
							S.next_scheduled_generation := Modelica.Constants.inf "next process ending is scheduled at infinite";
							S.events_processed := S.events_processed + outputBatchDimension "events processed are augmented";
							S.events_in_batch := outputBatchDimension "events to be sent are put into batch";
							if not S.blocked_output then
								S.immediate_transition_required := true;
								if sendEventsSingularly then
									S.events_in_batch := S.events_in_batch - 1;
									S.events_being_sent := 1;
								else
									S.events_being_sent := S.events_in_batch;
									S.events_in_batch := 0;						
								end if "if events have to be sent one by one, send one, otherwise send entire batch";
								if S.events_in_batch == 0 then
									S.request := S.request + requestDimension "a request is elaborated";
          						end if "if no more events would remain to be sent, send a request too";
							end if "if output ports are open events can be sent too";
						elseif not S.active then							
							if S.events_being_sent > 0 then
								S.events_already_sent := S.events_already_sent + S.events_being_sent "if an event had been sent during the last transition, add it to the already sent events";
								S.events_being_sent := 0;
								if S.events_in_batch > 0 then
									if not S.blocked_output then
										S.immediate_transition_required := true "if an event has been sent but there are still and the ports are open schedule a transition with no outputs";
									end if;
								elseif S.events_in_batch <= 0 then
									if S.events_in_buffer >= requestDimension then //if there are enough events to start the process
										S.next_scheduled_generation := time + RNGBlock.randomValue "the next process is scheduled to be finished at the actual time plus the parameter time advance";
										RNGBlock.trigger := RNGBlock.trigger + 1 "augmenting the RNG trigger to require the generation of a new random number";
										S.active := true "starting a process the server turns to active";
										S.events_in_buffer := S.events_in_buffer - requestDimension "events ready to be processed are reduced";
									end if;
								end if;	
							elseif S.events_being_sent <= 0 then
								if S.events_in_batch > 0 then
									if not S.blocked_output then
										S.immediate_transition_required := true "if no events have been sent at the last transition, but still there are and outputs are open, trigger a new transition to send new ones";
										if sendEventsSingularly then
											S.events_in_batch := S.events_in_batch - 1;
											S.events_being_sent := 1;
										else
											S.events_being_sent := S.events_in_batch;
											S.events_in_batch := 0;								
										end if "if events have to be sent one by one, send one, otherwise send entire batch";
										if S.events_in_batch == 0 then
            								S.request := S.request + requestDimension "a request is elaborated";
          								end if "if no more events would remain to be sent, send a request too";
									end if;
								elseif S.events_in_batch <= 0 then
									if S.events_in_buffer >= requestDimension then //if there are enough events to start the process
										S.next_scheduled_generation := time + RNGBlock.randomValue "the next process is scheduled to be finished at the actual time plus the parameter time advance";
										RNGBlock.trigger := RNGBlock.trigger + 1 "augmenting the RNG trigger to require the generation of a new random number";
										S.active := true "starting a process the server turns to active";
										S.events_in_buffer := S.events_in_buffer - requestDimension "events ready to be processed are reduced";
									end if "if no events are left to send and there are enough events ready to process, start one";
								end if;	
							end if;							
						end if "if before this internal event server was active, it means that a process has been completed and that the server needs to be deactivated. Otherwise sending of events needs to be managed";
						
						if S.immediate_transition_required then
							S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
						elseif S.active then
							S.next_TS := S.next_scheduled_generation;
						elseif S.blocked_output then
							S.next_TS := Modelica.Constants.inf "in any case, if output ports are blocked next internal transition is scheduled at infinite time";
						else
							S.next_TS := S.next_scheduled_generation "otherwise the next internal event will be when normally scheduled";
						end if "if to evaluate next_TS in relation to the output being blocked";
						
					elsewhen pre(external_transition) then
					//EXTERNAL TRANSITION CODE
						S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
						
						S.blocked_output := false "At the beginning of every transition it is assumed that the output is not blocked, to then check for every port"; 
						for i in 1:n_outputs loop
							if X.portBlocked[i] then
								S.blocked_output := true "If any port is found blocked the whole system considers the output blocked"; 
							end if;
						end for "loop aimed at checking if any of the output ports is considered blocked"; 
						
						for i in 1:n_inputs loop
							S.events_in_buffer := S.events_in_buffer + X.eventsArrived[i] - S.events_acquired[i] "number of events ready to be processed are updated by the difference between actual and previous inputs";
							S.events_acquired[i] := X.eventsArrived[i] "at the next transition previous input elements will be equal to the actual ones";
						end for "for loop to acquire arrived events";	
						
						if S.events_in_buffer >= requestDimension and not S.active and S.events_in_batch == 0 then //if there are enough events to start the process
							S.next_scheduled_generation := time + RNGBlock.randomValue "the next process is scheduled to be finished at the actual time plus the parameter time advance";
							RNGBlock.trigger := RNGBlock.trigger + 1 "augmenting the RNG trigger to require the generation of a new random number";
							S.active := true "starting a process the server turns to active";
							S.events_in_buffer := S.events_in_buffer - requestDimension "events ready to be processed are reduced";
						elseif S.events_in_batch > 0 and not S.blocked_output then
							S.immediate_transition_required := true "if after an external event there are still events to send and output ports happen to be open, trigger an immediate internal event to send events";
							if sendEventsSingularly then
								S.events_in_batch := S.events_in_batch - 1;
								S.events_being_sent := 1;
							else
								S.events_being_sent := S.events_in_batch;
								S.events_in_batch := 0;								
							end if "if events have to be sent one by one, send one, otherwise send entire batch";
							if S.events_in_batch == 0 then
								S.request := S.request + requestDimension "a request is elaborated";
							end if "if no more events would remain to be sent, send a request too";
						end if;
						
						if S.immediate_transition_required then
							S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
						elseif S.active then
							S.next_TS := S.next_scheduled_generation;
						elseif S.blocked_output then
							S.next_TS := Modelica.Constants.inf "in any case, if output ports are blocked next internal transition is scheduled at infinite time";
						else
							S.next_TS := S.next_scheduled_generation "otherwise the next internal event will be when normally scheduled";
						end if "if to evaluate next_TS in relation to the output being blocked";				
						
					elsewhen pre(internal_transition) then
					//INTERNAL TRANSITION CODE
						S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
						
						if S.active then
							S.active := false "if server was active after an internal event it needs to be deactivated";
							S.next_scheduled_generation := Modelica.Constants.inf "next process ending is scheduled at infinite";
							S.events_processed := S.events_processed + outputBatchDimension "events processed are augmented";
							S.events_in_batch := outputBatchDimension "events to be sent are put into batch";
							if not S.blocked_output then
								S.immediate_transition_required := true;
								if sendEventsSingularly then
									S.events_in_batch := S.events_in_batch - 1;
									S.events_being_sent := 1;
								else
									S.events_being_sent := S.events_in_batch;
									S.events_in_batch := 0;								
								end if "if events have to be sent one by one, send one, otherwise send entire batch";
								if S.events_in_batch == 0 then
            						S.request := S.request + requestDimension "a request is elaborated";
          						end if "if no more events would remain to be sent, send a request too";
							end if "if output ports are open events can be sent too";
						elseif not S.active then							
							if S.events_being_sent > 0 then
								S.events_already_sent := S.events_already_sent + S.events_being_sent "if an event had been sent during the last transition, add it to the already sent events";
								S.events_being_sent := 0;
								if S.events_in_batch > 0 then
									if not S.blocked_output then
										S.immediate_transition_required := true "if an event has been sent but there are still and the ports are open schedule a transition with no outputs";
									end if;
								elseif S.events_in_batch <= 0 then
									if S.events_in_buffer >= requestDimension then //if there are enough events to start the process
										S.next_scheduled_generation := time + RNGBlock.randomValue "the next process is scheduled to be finished at the actual time plus the parameter time advance";
										RNGBlock.trigger := RNGBlock.trigger + 1 "augmenting the RNG trigger to require the generation of a new random number";
										S.active := true "starting a process the server turns to active";
										S.events_in_buffer := S.events_in_buffer - requestDimension "events ready to be processed are reduced";
									end if;
								end if;	
							elseif S.events_being_sent <= 0 then
								if S.events_in_batch > 0 then
									if not S.blocked_output then
										S.immediate_transition_required := true "if no events have been sent at the last transition, but still there are and outputs are open, trigger a new transition to send new ones";
										if sendEventsSingularly then
											S.events_in_batch := S.events_in_batch - 1;
											S.events_being_sent := 1;
										else
											S.events_being_sent := S.events_in_batch;
											S.events_in_batch := 0;								
										end if "if events have to be sent one by one, send one, otherwise send entire batch";
										if S.events_in_batch == 0 then
            								S.request := S.request + requestDimension "a request is elaborated";
          								end if "if no more events would remain to be sent, send a request too";
									end if;
								elseif S.events_in_batch <= 0 then
									if S.events_in_buffer >= requestDimension then //if there are enough events to start the process
										S.next_scheduled_generation := time + RNGBlock.randomValue "the next process is scheduled to be finished at the actual time plus the parameter time advance";
										RNGBlock.trigger := RNGBlock.trigger + 1 "augmenting the RNG trigger to require the generation of a new random number";
										S.active := true "starting a process the server turns to active";
										S.events_in_buffer := S.events_in_buffer - requestDimension "events ready to be processed are reduced";
									end if "if no events are left to send and there are enough events ready to process, start one";
								end if;	
							end if;							
						end if "if before this internal event server was active, it means that a process has been completed and that the server needs to be deactivated. Otherwise sending of events needs to be managed";
						
						if S.immediate_transition_required then
							S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
						elseif S.active then
							S.next_TS := S.next_scheduled_generation;
						elseif S.blocked_output then
							S.next_TS := Modelica.Constants.inf "in any case, if output ports are blocked next internal transition is scheduled at infinite time";
						else
							S.next_TS := S.next_scheduled_generation "otherwise the next internal event will be when normally scheduled";
						end if "if to evaluate next_TS in relation to the output being blocked";
					
					end when;	
				///////////////////////////////////////////////////////////////////////
				//                     END OF TRANSITIONS CODE                       //
				///////////////////////////////////////////////////////////////////////
				///////////////////////////////////////////////////////////////////////
				//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
				///////////////////////////////////////////////////////////////////////
				//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables
				algorithm
					when pre(external_event) then
						for i in 1:n_inputs loop
							X.eventsArrived[i] := pre(IN[i].event_signal);
						end for;
						for i in 1:n_outputs loop
							X.portBlocked[i] := pre(OUT[i].event_request_signal) == -1 "If the output port request's values is different from 0 the port is considered blocked";
						end for;
					end when;
				///////////////////////////////////////////////////////////////////////
				//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
				///////////////////////////////////////////////////////////////////////
				equation
					for i in 1:n_outputs loop
						OUT[i].event_signal = Y.eventsSent "outputs are equal to the events sent by the server";
						external_event[i + n_inputs] = change(OUT[i].event_request_signal);
					end for;
					for i in 1:n_inputs loop
						IN[i].event_request_signal = Y.request;
						external_event[i] = change(IN[i].event_signal);
					end for;
				end Server;
			  
			end Server_PKG;
			/////////////////////////////////////////////////////////////////////////
			//						END OF SERVER PACKAGE						//
			/////////////////////////////////////////////////////////////////////////
			
			
			
			/////////////////////////////////////////////////////////////////////////
			//							DELAY PACKAGE							//
			/////////////////////////////////////////////////////////////////////////
			package Delay_PKG
			
				record StateDel
					extends Atomic_PKG.State;
					parameter Integer capacity "amount of elements that can be delayed at the same time";
					parameter Integer n_inputs;
					discrete Real next_TS;
					discrete Real next_TS_array[capacity + 2 * n_inputs] "Array containg avalability times for every events stored";
					Integer previous_inputs[n_inputs] "Input events at the end of the last transition";		
					Boolean blocked_output "true when OUT.event_request_signal differs from zero, thus output is blocked";			
					Integer events_waiting "elements inside the delay block";
					Integer events_already_sent "elements sent out of the block";
					Integer events_being_sent "amount of elements that are sent at transition";
					Boolean immediate_transition_required "used to indicate that an internal transition has to be fired immediately to change settings in the input";
					Boolean blocking_input "true if input has to be blocked";
					Integer events_discarded;
					Integer RNGState[33];
					discrete Real timeadvance;
					Integer request_value;
				end StateDel;
				
				record InputVariables_XDel
					extends Atomic_PKG.InputVariables_X;
					parameter Integer n_inputs;
					parameter Integer n_outputs;
					Integer eventsArrived[n_inputs] "number of elements arrived in input";
					Boolean portBlocked[n_outputs] "Array that stores information about blockage of output ports (an output port is considered blocked when its request value -1)";
					Integer requestValue;
				end InputVariables_XDel;
				
				record OutputVariables_YDel
					extends Atomic_PKG.OutputVariables_Y;
					Integer eventsSent "elements sent as output";
					Integer inputPortsValue "Value used to eventually block input ports";
				end OutputVariables_YDel;
			  
				block Delay
					annotation(
    Documentation(info = "<HTML>
    
	<b>Delay</b><br>
<br>
A delay block receives events and outputs them after a certain amount of time, delaying their route inside the system. It can take events from many input ports and it can send simultaneously multiple events through its outport ports. If any of the output ports is blocked, the delay block doesn't send events.<br>
Every delay block has a defined and limited capacity of events that can be simultaneously delayed, and when that capacity is reached input ports are blocked. Nonetheless, an additional storing space is always kept outside of the nominal value, to account for an excess of events.<br>
The delay imposed by the block can be of stochastic nature, in this case the order with which events will exit the block is not guaranteed to be the same of entering.<br>
With a specific setup, the delay block can be used to model the service time need by a queue to transport an event to a server, by inserting a delay block with one input and one output in the middle of the queue's and server's ports. The delay block will transfer requests from the server to the queue, and thus will receive events that will be transmitted after the required amount of time. Remember that it is necessary to employ a delay with enough capacity to contain all the events requested by the server, and that the delay can't take requests from more than one server, since managing many different pending request from different ports is not one of its properties.<br>
Together with the delay time, the following parameters define the block's behaviour:

<ul>
<li> <b>capacity</b> defines the maximum amount of events that the block is supposed to simultaneously store.
</li><li> <b>sendEventsSingularly</b> if true batches of events will be sent one by one, to let the receiver a transition step to close its ports if necessary. If the system being modeled has no serious constraints on capacity, this parameter can be set to false so that all events will be sent together in the space of a unique transition. Having less transitions to inspect can be more convenient when simulation events are analyzed.
</li><li> <b>allowCapacityExceeding</b> can be used to specify whether or not events surpassing the capacity limit will be kept or discarded. Every delay block has an additional space for events equal to twice the number of input ports. When even this additional space finishes, the block automatically discards exceeding events indipendently from this parameter.
</ul>


</HTML>"));
					extends Atomic_PKG.Atomic(redeclare StateDel S(capacity = capacity, n_inputs = n_inputs), redeclare OutputVariables_YDel Y, redeclare InputVariables_XDel X(n_inputs = n_inputs, n_outputs = n_outputs), n_inputs = inputsNumber, redeclare Boolean external_event[n_inputs + n_outputs], n_outputs = outputsNumber);
					parameter Integer inputsNumber = 1 "number of input ports of the system";
					parameter Integer outputsNumber = 1 "number of output ports of the system";			
					parameter Integer capacity = 100 "amount of elements that can be delayed at the same time";
					parameter Integer localSeed = 9 "localSeed of the RNG";
					parameter Integer globalSeed = 12 "globalSeed of the RNG";
					parameter Integer distributionSelected = 0 "0 = constant; 1 = uniform; 2 = exponential";
					parameter Real distributionParameter1 = 1;
					parameter Real distributionParameter2 = 0 "used only in uniform distribution to set the bias of the random number";
					parameter Boolean sendEventsSingularly = true "if true, events ready to be sent are sent in a unique batch, otherwise multiple sendings are executed for all the available events. In case the block at the end has a certain capacity, it is advised to keep this value true to avoid events being discarded. Otherwise, if no such strictness is required, transmissions of batches of events can be activated by setting to false this parameters. Calculation performances would increase";
					parameter Boolean allowCapacityExceeding = true;
					EventsLib.Interfaces.In_Port IN[n_inputs] annotation(
		          Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
					EventsLib.Interfaces.Out_Port OUT[n_outputs] annotation(
		          Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
				initial algorithm
					S.events_waiting := 0;
					S.events_already_sent := 0;
					S.events_being_sent := 0;
					S.RNGState := Modelica.Math.Random.Generators.Xorshift1024star.initialState(localSeed, globalSeed);
					for i in 1:size(S.next_TS_array, 1) loop
						S.next_TS_array[i] := Modelica.Constants.inf;
					end for;
					S.next_TS := Modelica.Constants.inf;
					next_TS := S.next_TS;
					S.blocked_output := S.events_waiting >= capacity;
					S.immediate_transition_required := S.blocked_output;
					for i in 1:n_inputs loop
						S.previous_inputs[i] := 0;
					end for;
					Y.inputPortsValue := 0;
				algorithm
				//UPDATING next_TS
					when pre(transition_happened) then
						next_TS := S.next_TS "After every transition next_TS equals the value set into the state";
					end when;
				algorithm
					when pre(internal_transition_planned[1]) then
						Y.eventsSent := S.events_already_sent + S.events_being_sent;
						if S.blocking_input then
							Y.inputPortsValue := -1;
						else
							Y.inputPortsValue := S.request_value;
						end if "If output ports are set ot  be blocked then request value is set to -1";
					/*elsewhen internal_transition_planned[2] then
						for i in 1:n_inputs loop
							IN[i].event_request_signal := Y.inputPortsValue;
						end for;
						for i in 1:n_outputs loop
							OUT[i].event_signal := Y.eventsSent[i];
						end for;*/
					end when;
				///////////////////////////////////////////////////////////////////////
				//                        TRANSITIONS CODE                           //
				///////////////////////////////////////////////////////////////////////
				algorithm
					when pre(confluent_transition) then
					//CONFLUENT TRANSITION CODE
						
						S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
						if S.events_being_sent > 0 then
							S.events_already_sent := S.events_already_sent + S.events_being_sent "after every internal transition update the amount of elements already sent";
							for i in 1:S.events_waiting loop
								if i + S.events_being_sent <= size(S.next_TS_array, 1) then
									S.next_TS_array[i] := S.next_TS_array[i + S.events_being_sent];
								else
									S.next_TS_array[i] := Modelica.Constants.inf;
								end if;
							end for;
							S.events_waiting := S.events_waiting - S.events_being_sent;
						end if "if at the last transtition some elements have been sent, pull them out of the queue";
						for i in 1:n_inputs loop
							for i in 1:(X.eventsArrived[i] - S.previous_inputs[i]) loop
								if S.events_waiting + 1 <= capacity or (S.events_waiting + 1 <= size(S.next_TS_array, 1) and allowCapacityExceeding) then
									S.events_waiting := S.events_waiting + 1;
									(S.timeadvance, S.RNGState) := Modelica.Math.Random.Generators.Xorshift1024star.random(S.RNGState);
									if distributionSelected == 1 then
										S.timeadvance := S.timeadvance * distributionParameter1 + distributionParameter2;
									elseif distributionSelected == 2 then
										S.timeadvance := -Modelica.Math.log(S.timeadvance) / distributionParameter1;
									else	
										S.timeadvance := distributionParameter1;
									end if;									
									S.next_TS_array[S.events_waiting] := time + S.timeadvance;
								else
									S.events_discarded := S.events_discarded + 1;
								end if;
							end for;
							S.previous_inputs[i] := X.eventsArrived[i];
						end for "Cicle aimed at updating the elements_arrived value";
						
						if not distributionSelected == 0 then
							S.next_TS_array := Modelica.Math.Vectors.sort(S.next_TS_array);
						end if;
						
						S.blocked_output := false "At the beginning of every transition it is assumed that the output is not blocked, to then check for every port"; 
						for i in 1:n_outputs loop
							if X.portBlocked[i] then
								S.blocked_output := true "If any port is found blocked the whole system considers the output blocked"; 
							end if;
						end for "loop aimed at checking if any of the output ports is considered blocked";
						
						if S.events_waiting >= capacity and not S.blocking_input then
							S.blocking_input := true;
							S.immediate_transition_required := true;
						elseif S.events_waiting < capacity and S.blocking_input then
							S.blocking_input := false;
							S.immediate_transition_required := true;
						end if;
						
						if X.requestValue > S.request_value then
							S.immediate_transition_required := true;
							S.request_value := X.requestValue;
						end if;
						
						if S.events_being_sent > 0 then
							S.events_being_sent := 0;
							if S.next_TS_array[1] <= time and not S.blocked_output then
								S.immediate_transition_required := true "if an event has been sent but there are still and the ports are open schedule a transition with no outputs";
							end if;
						elseif S.next_TS_array[1] <= time and not S.blocked_output then
							S.immediate_transition_required := true;
							if sendEventsSingularly then
								S.events_being_sent := 1;
							else
								S.events_being_sent := 0;
								for i in 1:size(S.next_TS_array, 1) loop
									if S.next_TS_array[i] <= time then
										S.events_being_sent := S.events_being_sent + 1;
									end if;
								end for;
							end if;
						end if;
						
						if S.immediate_transition_required then
							S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
						elseif S.blocked_output then
							S.next_TS := Modelica.Constants.inf "In case the output is blocked next internal event is delayed for undetermined time";
							S.events_being_sent := 0;
						else
							S.next_TS := S.next_TS_array[1];							
							if sendEventsSingularly and S.next_TS <= Modelica.Constants.inf then
								S.events_being_sent := 1;
							else
								S.events_being_sent := 0;
								for i in 1:size(S.next_TS_array, 1) loop
									if S.next_TS_array[i] <= S.next_TS or S.next_TS_array[i] <= time then
										S.events_being_sent := S.events_being_sent + 1;
									end if;
								end for;
							end if;
						end if;
						
					elsewhen pre(external_transition) then
					//EXTERNAL TRANSITION CODE
						
						
						for i in 1:n_inputs loop
							for i in 1:(X.eventsArrived[i] - S.previous_inputs[i]) loop
								if S.events_waiting + 1 <= capacity or (S.events_waiting + 1 <= size(S.next_TS_array, 1) and allowCapacityExceeding) then
									S.events_waiting := S.events_waiting + 1;
									(S.timeadvance, S.RNGState) := Modelica.Math.Random.Generators.Xorshift1024star.random(S.RNGState);
									if distributionSelected == 1 then
										S.timeadvance := S.timeadvance * distributionParameter1 + distributionParameter2;
									elseif distributionSelected == 2 then
										S.timeadvance := -Modelica.Math.log(S.timeadvance) / distributionParameter1;
									else	
										S.timeadvance := distributionParameter1;
									end if;									
									S.next_TS_array[S.events_waiting] := time + S.timeadvance;
								else
									S.events_discarded := S.events_discarded + 1;
								end if;									
							end for;
							S.previous_inputs[i] := X.eventsArrived[i];
						end for "Cicle aimed at updating the elements_arrived value";
						
						if not distributionSelected == 0 then
							S.next_TS_array := Modelica.Math.Vectors.sort(S.next_TS_array);
						end if;
						
						S.blocked_output := false "At the beginning of every transition it is assumed that the output is not blocked, to then check for every port"; 
						for i in 1:n_outputs loop
							if X.portBlocked[i] then
								S.blocked_output := true "If any port is found blocked the whole system considers the output blocked"; 
							end if;
						end for "loop aimed at checking if any of the output ports is considered blocked";
						
						if S.events_waiting >= capacity and not S.blocking_input then
							S.blocking_input := true;
							S.immediate_transition_required := true;
						elseif S.events_waiting < capacity and S.blocking_input then
							S.blocking_input := false;
							S.immediate_transition_required := true;
						end if;
						
						if X.requestValue > S.request_value then
							S.immediate_transition_required := true;
							S.request_value := X.requestValue;
						end if;
						
						//Evaluate how many events to send in output in case an immediate transition needs to be triggered
						if S.immediate_transition_required then
							if S.events_being_sent > 0 then
								S.events_being_sent := 0;
							elseif S.next_TS_array[1] <= time and not S.blocked_output then
								if sendEventsSingularly then
									S.events_being_sent := 1;
								else
									S.events_being_sent := 1;
									for i in 2:size(S.next_TS_array, 1) loop
										if S.next_TS_array[i] <= time then
											S.events_being_sent := S.events_being_sent + 1;
										end if;
									end for;
								end if;
							end if;
						end if;
						
						if S.immediate_transition_required then
							S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
						elseif S.blocked_output then
							S.next_TS := Modelica.Constants.inf "In case the output is blocked next internal event is delayed for undetermind time";
							S.events_being_sent := 0;
						else
							S.next_TS := S.next_TS_array[1];							
							if sendEventsSingularly and S.next_TS <= Modelica.Constants.inf then
								S.events_being_sent := 1;
							else
								S.events_being_sent := 0;
								for i in 1:size(S.next_TS_array, 1) loop
									if S.next_TS_array[i] <= S.next_TS or S.next_TS_array[i] <= time then
										S.events_being_sent := S.events_being_sent + 1;
									end if;
								end for;
							end if;
						end if;												
						
					elsewhen pre(internal_transition) then
					//INTERNAL TRANSITION CODE
						
						
						S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
						if S.events_being_sent > 0 then
							S.events_already_sent := S.events_already_sent + S.events_being_sent "after every internal transition update the amount of elements already sent";
							S.events_waiting := S.events_waiting - S.events_being_sent;
							for i in 1:S.events_waiting loop
								S.next_TS_array[i] := S.next_TS_array[i + S.events_being_sent];
							end for;
							for i in 1:S.events_being_sent loop
								if S.events_waiting + i <= size(S.next_TS_array, 1) then
									S.next_TS_array[S.events_waiting + i] := Modelica.Constants.inf;
								end if;
							end for;
						end if "if a the last transtition some elements have been sent, pull them out of the queue";
						
						if S.events_waiting >= capacity and not S.blocking_input then
							S.blocking_input := true;
							S.immediate_transition_required := true;
						elseif S.events_waiting < capacity and S.blocking_input then
							S.blocking_input := false;
							S.immediate_transition_required := true;
						end if;
						
						if S.events_being_sent > 0 then
							S.events_being_sent := 0;
							if S.next_TS_array[1] <= time and not S.blocked_output then
								S.immediate_transition_required := true "if an event has been sent but there are still and the ports are open schedule a transition with no outputs";
							end if;
						elseif S.next_TS_array[1] <= time and not S.blocked_output then
							S.immediate_transition_required := true;
							if sendEventsSingularly then
								S.events_being_sent := 1;
							else
								S.events_being_sent := 0;
								for i in 1:size(S.next_TS_array, 1) loop
									if S.next_TS_array[i] <= time then
										S.events_being_sent := S.events_being_sent + 1;
									end if;
								end for;
							end if;
						end if;
						
						if S.immediate_transition_required then
							S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
						elseif S.blocked_output then
							S.next_TS := Modelica.Constants.inf "In case the output is blocked next internal event is delayed for undetermind time";
							S.events_being_sent := 0;
						else
							S.next_TS := S.next_TS_array[1];							
							if sendEventsSingularly and S.next_TS <= Modelica.Constants.inf then
								S.events_being_sent := 1;
							else
								S.events_being_sent := 0;
								for i in 1:size(S.next_TS_array, 1) loop
									if S.next_TS_array[i] <= S.next_TS or S.next_TS_array[i] <= time then
										S.events_being_sent := S.events_being_sent + 1;
									end if;
								end for;
							end if;
						end if;
						
					end when;
				///////////////////////////////////////////////////////////////////////
				//                     END OF TRANSITIONS CODE                       //
				///////////////////////////////////////////////////////////////////////
				///////////////////////////////////////////////////////////////////////
				//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
				///////////////////////////////////////////////////////////////////////
				//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables	
				algorithm
					when pre(external_event) then
						for i in 1:n_inputs loop					
							X.eventsArrived[i] := pre(IN[i].event_signal);
						end for;
						for i in 1:n_outputs loop
							X.portBlocked[i] := pre(OUT[i].event_request_signal) == -1 "If the output port request's values is different from 0 the port is considered blocked";
						end for;
						X.requestValue := pre(OUT[1].event_request_signal);
					end when;
				///////////////////////////////////////////////////////////////////////
				//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
				///////////////////////////////////////////////////////////////////////
				equation
					for i in 1:n_inputs loop
						external_event[i] = change(IN[i].event_signal);
						IN[i].event_request_signal = Y.inputPortsValue;
					end for;
					for i in 1:n_outputs loop
						OUT[i].event_signal = Y.eventsSent;
						external_event[n_inputs + i] = change(OUT[i].event_request_signal);
					end for;
					
				end Delay;
			  
			end Delay_PKG;
			/////////////////////////////////////////////////////////////////////////
			//							END OF DELAY PACKAGE						//
			/////////////////////////////////////////////////////////////////////////
			
			
			
			/////////////////////////////////////////////////////////////////////////
			//							RANDOM SWITCH PACKAGE					//
			/////////////////////////////////////////////////////////////////////////
			package RandomSwitch_PKG
			
				record StateRSw
					extends Atomic_PKG.State;
					parameter Integer n_inputs;
					parameter Integer n_outputs;
					discrete Real next_TS;
					Integer events_waiting;
					Integer events_acquired[n_inputs];
					Boolean port_blocked[n_outputs];
					Integer events_already_sent[n_outputs];
					Integer events_being_sent[n_outputs];
					Integer RNGState[33];
					Boolean blocking_input;
					Boolean immediate_transition_required "boolean set to true everytime that the next status will have 0 lifetime";
					discrete Real random_decision;
				end StateRSw;
				
				record InputVariables_XRSw
					extends Atomic_PKG.InputVariables_X;
					parameter Integer n_inputs;
					parameter Integer n_outputs;
					Boolean portBlocked[n_outputs];
					Integer eventsArrived[n_inputs];
				end InputVariables_XRSw;
				
				record OutputVariables_YRSw
					extends Atomic_PKG.OutputVariables_Y;
					parameter Integer n_outputs;
					Integer eventsSent[n_outputs];
					Integer inputPortsValue;
				end OutputVariables_YRSw;
			  
				block RandomSwitch
					annotation(
    Documentation(info = "<HTML>
    
	<b>RandomSwitch</b><br>
<br>
A random switch receives events from possibly more than one input port and randomly redirects them towards one of its two output ports.

<ul>
<li> <b>sendEventsSingularly</b> if true batches of events will be sent one by one, to let the receiver some transition steps to close its ports if necessary. If the system being modeled has no serious constraints on capacity, this parameter can be set to false so that all events will be sent together in the space of a unique transition. Having less transitions to inspect can be more convenient when simulation events are analyzed.
</li><li> <b>allowDeterministicChoice</b> lets the user choose between two policies in case one output port becomes blocked. When the parameter is set to true, the block will automatically output incoming events towards the open port. If set to false, the random switch will behave like both output ports are blocked, thus it won't send anything and will close its input ports. Events already arrived will be retained with no capacity limit.
</li><li> <b>firstPortProbability</b> is the probability that an incoming event will be directed to the first output port. The second's port probability will be complementary to this parameter's value.
</ul>


</HTML>"));
					extends Atomic_PKG.Atomic(redeclare StateRSw S(n_inputs = n_inputs, n_outputs = n_outputs), redeclare OutputVariables_YRSw Y(n_outputs = n_outputs), redeclare InputVariables_XRSw X(n_inputs = n_inputs, n_outputs = n_outputs), n_inputs = inputsNumber, redeclare Boolean external_event[n_inputs + n_outputs], n_outputs = outputsNumber);
					parameter Integer inputsNumber = 1 "number of input ports of the system";
					constant Integer outputsNumber = 2 "number of output ports of the system";	
					parameter Integer localSeed = 9 "localSeed of the RNG";
					parameter Integer globalSeed = 12 "globalSeed of the RNG";		
					parameter Boolean sendEventsSingularly = true "if true, events ready to be sent are sent in a unique batch, otherwise multiple sendings are executed for all the available events. In case the block at the end has a certain capacity, it is advised to keep this value true to avoid events being discarded. Otherwise, if no such strictness is required, transmissions of batches of events can be activated by setting to false this parameters. Calculation performances would increase";
					parameter Boolean allowDeterministicChoice = true "true: in case one port is blocked, events automatically flow to the other port. false: if one port is blocked, sendings are stopped and input port is blocked";
					parameter Real firstPortProbability = 0.5 "probability that the arrived events are directed towards OUT1. 1 - firstPortProbability is the probability of OUT2 to output the event";
					EventsLib.Interfaces.In_Port IN[n_inputs] annotation(
		          Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
					EventsLib.Interfaces.Out_Port OUT1 annotation(
		          Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, 45}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
		          EventsLib.Interfaces.Out_Port OUT2 annotation(
		          Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, -45}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
				initial algorithm
					S.RNGState := Modelica.Math.Random.Generators.Xorshift1024star.initialState(localSeed, globalSeed);
					S.next_TS := Modelica.Constants.inf;
					next_TS := S.next_TS;
				algorithm
				//UPDATING next_TS
					when pre(transition_happened) then
						next_TS := S.next_TS "After every transition next_TS equals the value set into the state";
					end when;
				algorithm
					when pre(internal_transition_planned[1]) then
						for i in 1:n_outputs loop
							Y.eventsSent[i] := S.events_already_sent[i] + S.events_being_sent[i];
						end for;
						if S.blocking_input then
							Y.inputPortsValue := -1;
						else
							Y.inputPortsValue := 0;
						end if;
					end when;
				///////////////////////////////////////////////////////////////////////
				//                        TRANSITIONS CODE                           //
				///////////////////////////////////////////////////////////////////////
				algorithm
					when pre(confluent_transition) then
					//CONFLUENT TRANSITION CODE
						S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
						for i in 1:n_inputs loop
							if X.eventsArrived[i] > S.events_acquired[i] then
								S.events_waiting := S.events_waiting + X.eventsArrived[i] - S.events_acquired[i];
							end if;
							S.events_acquired[i] := X.eventsArrived[i];
						end for;
						
						for i in 1:n_outputs loop
							S.port_blocked[i] := X.portBlocked[i];
						end for "loop aimed at checking if any of the output ports is considered blocked";
						
						if S.blocking_input and ( (not max(S.port_blocked)) or (allowDeterministicChoice and not min(S.port_blocked))) then
							S.immediate_transition_required := true;
							S.blocking_input := false;
						elseif not S.blocking_input and ( (min(S.port_blocked)) or (not allowDeterministicChoice and max(S.port_blocked)) ) then
							S.immediate_transition_required := true;
							S.blocking_input := true;
						end if;
						
						if sum(S.events_being_sent) > 0 then
						
							for i in 1:n_outputs loop
								S.events_already_sent[i] := S.events_already_sent[i] + S.events_being_sent[i];
								S.events_being_sent[i] := 0;
							end for;
							if S.events_waiting > 0 and ( (allowDeterministicChoice and not min(S.port_blocked)) or (not allowDeterministicChoice and not max(S.port_blocked)) ) then
								S.immediate_transition_required := true;
							end if;
							
						else
							if S.events_waiting > 0 then
								
								if not max(S.port_blocked) then
									S.immediate_transition_required := true "A transmission will occur inside this event iteration chain";
									for i in 1:n_outputs loop
										S.events_being_sent[i] := 0;
									end for;
									
									for i in 1:(if sendEventsSingularly then 1 else S.events_waiting) loop
										(S.random_decision, S.RNGState) := Modelica.Math.Random.Generators.Xorshift1024star.random(S.RNGState);
										if S.random_decision <= firstPortProbability then
											S.events_being_sent[1] := S.events_being_sent[1] + 1;
											S.events_waiting := S.events_waiting - 1;
										else
											S.events_being_sent[2] := S.events_being_sent[2] + 1;
											S.events_waiting := S.events_waiting - 1;
										end if;
									end for;
								elseif allowDeterministicChoice and not min(S.port_blocked) then
									S.immediate_transition_required := true;
									if S.port_blocked[1] then
										if sendEventsSingularly then
											S.events_being_sent[2] := 1;
											S.events_waiting := S.events_waiting - 1;
										else
											S.events_being_sent[2] := S.events_waiting;
											S.events_waiting := 0;
										end if "if events have to be sent one by one, send one, otherwise send all the waiting events";
									else
										if sendEventsSingularly then
											S.events_being_sent[1] := 1;
											S.events_waiting := S.events_waiting - 1;
										else
											S.events_being_sent[1] := S.events_waiting;
											S.events_waiting := 0;
										end if "if events have to be sent one by one, send one, otherwise send all the waiting events";
									end if;
								end if;
								
							end if;
						end if;
						
						
						
						if S.immediate_transition_required then
							S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
						else
							S.next_TS := Modelica.Constants.inf;
						end if;
						
					elsewhen pre(external_transition) then
					//EXTERNAL TRANSITION CODE
						S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
						for i in 1:n_inputs loop
							if X.eventsArrived[i] > S.events_acquired[i] then
								S.events_waiting := S.events_waiting + X.eventsArrived[i] - S.events_acquired[i];
							end if;
							S.events_acquired[i] := X.eventsArrived[i];
						end for;
						
						
						for i in 1:n_outputs loop
							S.port_blocked[i] := X.portBlocked[i];
						end for "loop aimed at checking if any of the output ports is considered blocked";
						
						if S.blocking_input and ( (not max(S.port_blocked)) or (allowDeterministicChoice and not min(S.port_blocked))) then
							S.immediate_transition_required := true;
							S.blocking_input := false;
						elseif not S.blocking_input and ( (min(S.port_blocked)) or (not allowDeterministicChoice and max(S.port_blocked)) ) then
							S.immediate_transition_required := true;
							S.blocking_input := true;
						end if;
						
						if S.events_waiting > 0 then 
							if not max(S.port_blocked) then
								S.immediate_transition_required := true "A transmission will occur inside this event iteration chain";
								for i in 1:n_outputs loop
									S.events_being_sent[i] := 0;
								end for;
									
								for i in 1:(if sendEventsSingularly then 1 else S.events_waiting) loop
									(S.random_decision, S.RNGState) := Modelica.Math.Random.Generators.Xorshift1024star.random(S.RNGState);
									if S.random_decision <= firstPortProbability then
										S.events_being_sent[1] := S.events_being_sent[1] + 1;
										S.events_waiting := S.events_waiting - 1;
									else
										S.events_being_sent[2] := S.events_being_sent[2] + 1;
										S.events_waiting := S.events_waiting - 1;
									end if;
								end for;
							elseif allowDeterministicChoice and not min(S.port_blocked) then
								S.immediate_transition_required := true;
								if S.port_blocked[1] then
									if sendEventsSingularly then
										S.events_being_sent[2] := 1;
										S.events_waiting := S.events_waiting - 1;
									else
										S.events_being_sent[2] := S.events_waiting;
										S.events_waiting := 0;
									end if "if events have to be sent one by one, send one, otherwise send all the waiting events";
								else
									if sendEventsSingularly then
										S.events_being_sent[1] := 1;
										S.events_waiting := S.events_waiting - 1;
									else
										S.events_being_sent[1] := S.events_waiting;
										S.events_waiting := 0;
									end if "if events have to be sent one by one, send one, otherwise send all the waiting events";
								end if;
							end if;
						end if;
						
						if S.immediate_transition_required then
							S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
						else
							S.next_TS := Modelica.Constants.inf;
						end if;
																	
						
					elsewhen pre(internal_transition) then
					//INTERNAL TRANSITION CODE
						S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
						if sum(S.events_being_sent) > 0 then
						
							for i in 1:n_outputs loop
								S.events_already_sent[i] := S.events_already_sent[i] + S.events_being_sent[i];
								S.events_being_sent[i] := 0;
							end for;
							if S.events_waiting > 0 and ( (allowDeterministicChoice and not min(S.port_blocked)) or (not allowDeterministicChoice and not max(S.port_blocked)) ) then
								S.immediate_transition_required := true;
							end if;
							
						else
							if S.events_waiting > 0 then
								
								if not max(S.port_blocked) then
									S.immediate_transition_required := true "A transmission will occur inside this event iteration chain";
									for i in 1:n_outputs loop
										S.events_being_sent[i] := 0;
									end for;
									
									for i in 1:(if sendEventsSingularly then 1 else S.events_waiting) loop
										(S.random_decision, S.RNGState) := Modelica.Math.Random.Generators.Xorshift1024star.random(S.RNGState);
										if S.random_decision <= firstPortProbability then
											S.events_being_sent[1] := S.events_being_sent[1] + 1;
											S.events_waiting := S.events_waiting - 1;
										else
											S.events_being_sent[2] := S.events_being_sent[2] + 1;
											S.events_waiting := S.events_waiting - 1;
										end if;
									end for;
								elseif allowDeterministicChoice and not min(S.port_blocked) then
									S.immediate_transition_required := true;
									if S.port_blocked[1] then
										if sendEventsSingularly then
											S.events_being_sent[2] := 1;
											S.events_waiting := S.events_waiting - 1;
										else
											S.events_being_sent[2] := S.events_waiting;
											S.events_waiting := 0;
										end if;
									else
										if sendEventsSingularly then
											S.events_being_sent[1] := 1;
											S.events_waiting := S.events_waiting - 1;
										else
											S.events_being_sent[1] := S.events_waiting;
											S.events_waiting := 0;
										end if;
									end if;
								end if;
								
							end if;
						end if;
						
						if S.immediate_transition_required then
							S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
						else
							S.next_TS := Modelica.Constants.inf;
						end if;
					end when;
				///////////////////////////////////////////////////////////////////////
				//                     END OF TRANSITIONS CODE                       //
				///////////////////////////////////////////////////////////////////////
				///////////////////////////////////////////////////////////////////////
				//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
				///////////////////////////////////////////////////////////////////////
				//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables	
				algorithm
					when pre(external_event) then
						for i in 1:n_inputs loop					
							X.eventsArrived[i] := pre(IN[i].event_signal);
						end for;						
						X.portBlocked[1] := pre(OUT1.event_request_signal) == -1 "If the output port request's values is -1 the port is considered blocked";
						X.portBlocked[2] := pre(OUT2.event_request_signal) == -1 "If the output port request's values is -1 the port is considered blocked";
						
					end when;
				///////////////////////////////////////////////////////////////////////
				//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
				///////////////////////////////////////////////////////////////////////
				equation
					for i in 1:n_inputs loop
						external_event[i] = change(IN[i].event_signal);
						IN[i].event_request_signal = Y.inputPortsValue;
					end for;
					OUT1.event_signal = Y.eventsSent[1];
					OUT2.event_signal = Y.eventsSent[2];
					external_event[n_inputs + 1] = change(OUT1.event_request_signal);
					external_event[n_inputs + 2] = change(OUT2.event_request_signal);
					
				end RandomSwitch;
			  
			end RandomSwitch_PKG;
			/////////////////////////////////////////////////////////////////////////
			//							END OF RANDOM SWITCH PACKAGE				//
			/////////////////////////////////////////////////////////////////////////
						
			
			
			/////////////////////////////////////////////////////////////////////////
			//							COMBINER PACKAGE							//
			/////////////////////////////////////////////////////////////////////////
			package Combiner_PKG
			
				record StateCmb
					extends Atomic_PKG.State;
					discrete Real next_TS;
					Integer events_already_sent;
					Integer events_being_sent;
					Integer events_waiting;
					Integer events_stored1;
					Integer events_stored2;
					Integer events_acquired1;
					Integer events_acquired2;
					Boolean blocked_output;
					Boolean blocking_input;
					Boolean immediate_transition_required "boolean set to true everytime that the next status will have 0 lifetime";
				end StateCmb;
				
				record InputVariables_XCmb
					extends Atomic_PKG.InputVariables_X;
					parameter Integer n_outputs;
					Boolean portBlocked[n_outputs];
					Integer eventsArrived1;
					Integer eventsArrived2;
				end InputVariables_XCmb;
				
				record OutputVariables_YCmb
					extends Atomic_PKG.OutputVariables_Y;
					Integer eventsSent;
					Integer inputPortsValue;
				end OutputVariables_YCmb;
			  
				block Combiner
					annotation(
    Documentation(info = "<HTML>
    
	<b>Combiner</b><br>
<br>
The combiner block receives events from two different input ports and merges them into a unique batch of events. Multiple batches of events can be eventually sent through multiple output ports.<br>
When any of its output ports is blocked it blocks its two inputs. The parameters below can be used to define its behaviour:

<ul>
<li> <b>eventsRequired1</b> is the amount of events coming from the first port required to generate a batch of combined events.
</li><li> <b>eventsRequired2</b> is the amount of events coming from the second port required to generate a batch of combined events.
</li><li> <b>outputBatchDimension</b> is the amount of events generated for every successful combination.
</li><li> <b>sendEventsSingularly</b> if true batches of events will be sent one by one, to let the receiver a transition step to close its ports if necessary. If the system being modeled has no serious constraints on capacity, this parameter can be set to false so that all events will be sent together in the space of a unique transition. Having less transitions to inspect can be more convenient when simulation events are analyzed.
</ul>


</HTML>"));
					extends Atomic_PKG.Atomic(redeclare StateCmb S, redeclare OutputVariables_YCmb Y, redeclare InputVariables_XCmb X(n_outputs = n_outputs), n_inputs = inputsNumber, redeclare Boolean external_event[n_inputs + n_outputs], n_outputs = outputsNumber);
					constant Integer inputsNumber = 2 "number of input ports of the system";
					parameter Integer outputsNumber = 1 "number of output ports of the system";
					parameter Integer eventsRequired1 = 1 "amount of events coming from port 1 required to generate a new event";
					parameter Integer eventsRequired2 = 1 "amount of events coming from port 2 required to generate a new event";
					parameter Integer outputBatchDimension = 1 "amount of events generated for every combining";
					parameter Boolean sendEventsSingularly = true "if true, events ready to be sent are sent in a unique batch, otherwise multiple sendings are executed for all the available events. In case the block at the end has a certain capacity, it is advised to keep this value true to avoid events being discarded. Otherwise, if no such strictness is required, transmissions of batches of events can be activated by setting to false this parameters. Calculation performances would increase";

					EventsLib.Interfaces.In_Port IN1 annotation(
		          Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 45}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
		          	EventsLib.Interfaces.In_Port IN2 annotation(
		          Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, -45}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
					EventsLib.Interfaces.Out_Port OUT[n_outputs] annotation(
		          Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, 45}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
				initial algorithm
					
					S.next_TS := Modelica.Constants.inf;
					next_TS := S.next_TS;
				algorithm
				//UPDATING next_TS
					when pre(transition_happened) then
						next_TS := S.next_TS "After every transition next_TS equals the value set into the state";
					end when;
				algorithm
					when pre(internal_transition_planned[1]) then
						
						Y.eventsSent := S.events_already_sent + S.events_being_sent;
						
						if S.blocking_input then
							Y.inputPortsValue := -1;
						else
							Y.inputPortsValue := 0;
						end if;
					end when;
				///////////////////////////////////////////////////////////////////////
				//                        TRANSITIONS CODE                           //
				///////////////////////////////////////////////////////////////////////
				algorithm
					when pre(confluent_transition) then
					//CONFLUENT TRANSITION CODE
						S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
						
						S.blocked_output := false "At the beginning of every transition it is assumed that the output is not blocked, to then check for every port"; 
						for i in 1:n_outputs loop
							if X.portBlocked[i] then
								S.blocked_output := true "If any port is found blocked the whole system considers the output blocked"; 
							end if;
						end for "loop aimed at checking if any of the output ports is considered blocked";
						
						if X.eventsArrived1 > S.events_acquired1 then
							S.events_stored1 := S.events_stored1 + X.eventsArrived1 - S.events_acquired1;
							S.events_acquired1 := X.eventsArrived1;
						end if;
						if X.eventsArrived2 > S.events_acquired2 then
							S.events_stored2 := S.events_stored2 + X.eventsArrived2 - S.events_acquired2;
							S.events_acquired2 := X.eventsArrived2;
						end if;
						
						while S.events_stored2 >= eventsRequired2 and S.events_stored1 >= eventsRequired1 loop
							S.events_stored1 := S.events_stored1 - eventsRequired1;
							S.events_stored2 := S.events_stored2 - eventsRequired2;
							S.events_waiting := S.events_waiting + outputBatchDimension;
						end while;
						
						if S.blocked_output and not S.blocking_input then
							S.immediate_transition_required := true;
							S.blocking_input := true;
						elseif not S.blocked_output and S.blocking_input then
							S.immediate_transition_required := true;
							S.blocking_input := false;
						end if;
						
						if S.events_being_sent > 0 then
						
							S.events_already_sent := S.events_already_sent + S.events_being_sent "if an event had been sent during the last transition, add it to the already sent events";
							S.events_being_sent := 0;
							if S.events_waiting > 0 and not S.blocked_output then
								S.immediate_transition_required := true "if an event has been sent but there are still and the ports are open schedule a transition with no outputs";
							end if;
						
						else
						
							if S.events_waiting > 0 and not S.blocked_output then
								S.immediate_transition_required := true;
								if sendEventsSingularly then
									S.events_being_sent := 1;
									S.events_waiting := S.events_waiting - 1;
								else
									S.events_being_sent := S.events_waiting;
									S.events_waiting := 0;
								end if  "if events have to be sent one by one, send one, otherwise send all the waiting events";
							end if;
						
						end if;
						
						if S.immediate_transition_required then
							S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
						else
							S.next_TS := Modelica.Constants.inf;
						end if;
						
					elsewhen pre(external_transition) then
					//EXTERNAL TRANSITION CODE
						S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
						
						S.blocked_output := false "At the beginning of every transition it is assumed that the output is not blocked, to then check for every port"; 
						for i in 1:n_outputs loop
							if X.portBlocked[i] then
								S.blocked_output := true "If any port is found blocked the whole system considers the output blocked"; 
							end if;
						end for "loop aimed at checking if any of the output ports is considered blocked";
						
						if X.eventsArrived1 > S.events_acquired1 then
							S.events_stored1 := S.events_stored1 + X.eventsArrived1 - S.events_acquired1;
							S.events_acquired1 := X.eventsArrived1;
						end if;
						if X.eventsArrived2 > S.events_acquired2 then
							S.events_stored2 := S.events_stored2 + X.eventsArrived2 - S.events_acquired2;
							S.events_acquired2 := X.eventsArrived2;
						end if;
						
						while S.events_stored2 >= eventsRequired2 and S.events_stored1 >= eventsRequired1 loop
							S.events_stored1 := S.events_stored1 - eventsRequired1;
							S.events_stored2 := S.events_stored2 - eventsRequired2;
							S.events_waiting := S.events_waiting + outputBatchDimension;
						end while;
						
						if S.blocked_output and not S.blocking_input then
							S.immediate_transition_required := true;
							S.blocking_input := true;
						elseif not S.blocked_output and S.blocking_input then
							S.immediate_transition_required := true;
							S.blocking_input := false;
						end if;
						
						if S.events_waiting > 0 and not S.blocked_output then
							S.immediate_transition_required := true;
							if sendEventsSingularly then
								S.events_being_sent := 1;
								S.events_waiting := S.events_waiting - 1;
							else
								S.events_being_sent := S.events_waiting;
								S.events_waiting := 0;
							end if  "if events have to be sent one by one, send one, otherwise send all the waiting events";
						end if;
						
						if S.immediate_transition_required then
							S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
						else
							S.next_TS := Modelica.Constants.inf;
						end if;
																	
						
					elsewhen pre(internal_transition) then
					//INTERNAL TRANSITION CODE
						S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
						
						if S.events_being_sent > 0 then
						
							S.events_already_sent := S.events_already_sent + S.events_being_sent "if an event had been sent during the last transition, add it to the already sent events";
							S.events_being_sent := 0;
							if S.events_waiting > 0 and not S.blocked_output then
								S.immediate_transition_required := true "if an event has been sent but there are still and the ports are open schedule a transition with no outputs";
							end if;
						
						else
						
							if S.events_waiting > 0 and not S.blocked_output then
								S.immediate_transition_required := true;
								if sendEventsSingularly then
									S.events_being_sent := 1;
									S.events_waiting := S.events_waiting - 1;
								else
									S.events_being_sent := S.events_waiting;
									S.events_waiting := 0;
								end if "if events have to be sent one by one, send one, otherwise send all the waiting events";
							end if;
						
						end if;
						
						if S.immediate_transition_required then
							S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
						else
							S.next_TS := Modelica.Constants.inf;
						end if;
						
					end when;
				///////////////////////////////////////////////////////////////////////
				//                     END OF TRANSITIONS CODE                       //
				///////////////////////////////////////////////////////////////////////
				///////////////////////////////////////////////////////////////////////
				//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
				///////////////////////////////////////////////////////////////////////
				//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables	
				algorithm
					when pre(external_event) then		
						X.eventsArrived1 := pre(IN1.event_signal);
						X.eventsArrived2 := pre(IN2.event_signal);
						for i in 1:n_outputs loop
							X.portBlocked[i] := pre(OUT[i].event_request_signal) == -1 "If the output port request's values is -1 the port is considered blocked";
						end for;
					end when;
				///////////////////////////////////////////////////////////////////////
				//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
				///////////////////////////////////////////////////////////////////////
				equation
					for i in 1:n_outputs loop
						external_event[i] = change(OUT[i].event_request_signal);
						OUT[i].event_signal = Y.eventsSent;
					end for;
					IN1.event_request_signal = Y.inputPortsValue;
					IN2.event_request_signal = Y.inputPortsValue;
					external_event[n_outputs + 1] = change(IN1.event_signal);
					external_event[n_outputs + 2] = change(IN2.event_signal);
					
				end Combiner;
			  
			end Combiner_PKG;
			/////////////////////////////////////////////////////////////////////////
			//							END OF COMBINER PACKAGE					//
			/////////////////////////////////////////////////////////////////////////
			
			
			
			/////////////////////////////////////////////////////////////////////////
			//						DISPLACER PACKAGE							//
			/////////////////////////////////////////////////////////////////////////
			package Displacer_PKG
			
				record StateDsp
					extends Atomic_PKG.State;
					parameter Integer n_inputs;
					Integer events_displaced "amount of events displaced by the system";
					Integer events_acquired[n_inputs] "amount of events already acquired from given input port";
				end StateDsp;
				
				record InputVariables_XDsp
					extends Atomic_PKG.InputVariables_X;
					parameter Integer n_inputs;
					Integer eventsArrived[n_inputs] "number of elements arrived in input";
				end InputVariables_XDsp;
				
				record OutputVariables_YDsp
					extends Atomic_PKG.OutputVariables_Y;
					Integer inputPortsRequestValue;
				end OutputVariables_YDsp;
				
				block Displacer
					annotation(
    Documentation(info = "<HTML>
    
	<b>Displacer</b><br>
<br>
The displacer receives events from its inputs and remove them from the system, that is, it doesn't transmit them anymore. It can be placed at the end of a working line to collect events which completed their lifecycle, eventually from more input ports.


</HTML>"));
					extends Atomic_PKG.Atomic(redeclare StateDsp S(n_inputs = n_inputs), redeclare OutputVariables_YDsp Y, redeclare InputVariables_XDsp X(n_inputs = n_inputs), n_inputs = inputsNumber, redeclare Boolean external_event[n_inputs + n_outputs], n_outputs = outputsNumber);
					parameter Integer inputsNumber = 1 "number of input ports of the system";
					constant Integer outputsNumber = 0 "number of output ports of the system";			
					EventsLib.Interfaces.In_Port IN[n_inputs] annotation(
		          Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
				initial algorithm
					next_TS := Modelica.Constants.inf;
				algorithm
				//UPDATING next_TS
					when pre(transition_happened) then
						next_TS := Modelica.Constants.inf;
					end when;
				algorithm
					when pre(internal_transition_planned[1]) then
						Y.inputPortsRequestValue := 0;
					end when;
				///////////////////////////////////////////////////////////////////////
				//                        TRANSITIONS CODE                           //
				///////////////////////////////////////////////////////////////////////
				algorithm
					when pre(confluent_transition) then
					//CONFLUENT TRANSITION CODE
						
					elsewhen pre(external_transition) then
					//EXTERNAL TRANSITION CODE
						for i in 1:n_inputs loop
							if X.eventsArrived[i] > S.events_acquired[i] then
								S.events_displaced := S.events_displaced + X.eventsArrived[i] - S.events_acquired[i];
								S.events_acquired[i] := X.eventsArrived[i];
							end if;
						end for;
					elsewhen pre(internal_transition) then
					//INTERNAL TRANSITION CODE
						
					end when;
				///////////////////////////////////////////////////////////////////////
				//                     END OF TRANSITIONS CODE                       //
				///////////////////////////////////////////////////////////////////////
				///////////////////////////////////////////////////////////////////////
				//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
				///////////////////////////////////////////////////////////////////////
				//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables	
				algorithm
					when pre(external_event) then
						for i in 1:n_inputs loop					
							X.eventsArrived[i] := pre(IN[i].event_signal);
						end for;
					end when;
				///////////////////////////////////////////////////////////////////////
				//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
				///////////////////////////////////////////////////////////////////////
				equation
					for i in 1:n_inputs loop
						external_event[i] = change(IN[i].event_signal);
						IN[i].event_request_signal = Y.inputPortsRequestValue;
					end for;
				end Displacer;
			  
			end Displacer_PKG;
			/////////////////////////////////////////////////////////////////////////
			//						END OF DISPLACER PACKAGE						//
			/////////////////////////////////////////////////////////////////////////
		  
		end BlocksPackages;
	
	
	end EventsLib;
	
	
	
	package I40Lab "Package in which events represent elements flowing on a conveyor belt of the I4.0 Lab plant"
	
		package Blocks
			block Generator = I40Lab.Generator_PKG.Generator;
			block Server = I40Lab.Server_PKG.Server;
			block DelayedQueue = I40Lab.DelayedQueue_PKG.DelayedQueue;
			block TwoWayQueue = I40Lab.TwoWayQueue_PKG.TwoWayQueue;
			block ReceivalDelayer = I40Lab.ReceivalDelayer_PKG.ReceivalDelayer;
			block Delay = I40Lab.Delay_PKG.Delay;
			block Displacer = I40Lab.Displacer_PKG.Displacer;
		end Blocks;
		
		package Interfaces
		  
			connector In_Port
				input Integer event_signal "Event arrival signal";
				output Integer event_request_signal "Channel to let the block require events";
				annotation(
      Icon(graphics = {Rectangle(origin = {0, -1}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 101}, {100, -99}}), Line(origin = {4.49296, -0.303664}, points = {{-35.6464, 72}, {36.3536, 0}, {-35.6464, -72}, {-35.6464, -72}}, color = {0, 0, 255}, thickness = 3)}, coordinateSystem(initialScale = 0.1)));
			end In_Port;

			connector Out_Port
				output Integer event_signal "Signal used to send signals";
				input Integer event_request_signal "Events communicated from blocks connected in output";
				annotation(
      Icon(graphics = {Rectangle(origin = {0, -1}, fillPattern = FillPattern.Solid, extent = {{-100, 101}, {100, -99}}, fillColor = {0, 0, 255}), Line(origin = {4.49296, -0.303664}, points = {{-35.6464, 72}, {36.3536, 0}, {-35.6464, -72}, {-35.6464, -72}}, color = {255, 255, 255}, thickness = 3)}));
			end Out_Port;
		  
		end Interfaces;
		
		package Functions
	
			function ImmediateInternalTransition "function used to decrement next internal transition time to trigger consecutive internal transitions"
				input Real next_TS_in;
				output Real next_TS_out;
			algorithm
				if next_TS_in >= 0 then
					next_TS_out := -1;
				else
					next_TS_out := next_TS_in - 1;
				end if;
			end ImmediateInternalTransition;

		end Functions;
		
		import MODES.EventsLib.RNG;
		/*package RNG
		
			block RandomGenerator
				parameter Integer localSeed = 10 "localSeed of the RNG";
				parameter Integer globalSeed = 7 "globalSeed of the RNG";
				parameter Integer distributionSelected = 0 "0 = constant; 1 = uniform; 2 = exponential";
				parameter Real distributionParameter1 = 1;
				parameter Real distributionParameter2 = 0 "used only in uniform distrib";
				discrete Real randomValue;
				input Integer trigger;
				Boolean number_request = change(trigger);
				parameter Real lower_limit = 0.00001;
			protected
				Integer RNGState[33];
			initial algorithm
				RNGState := Modelica.Math.Random.Generators.Xorshift1024star.initialState(localSeed, globalSeed);
				if distributionSelected == 1 then
					(randomValue, RNGState) := Modelica.Math.Random.Generators.Xorshift1024star.random(RNGState);
					randomValue := randomValue * distributionParameter1 + distributionParameter2;
				elseif distributionSelected == 2 then
					(randomValue, RNGState) := Modelica.Math.Random.Generators.Xorshift1024star.random(RNGState);
					randomValue := -Modelica.Math.log(randomValue) / distributionParameter1;
				else	
					randomValue := distributionParameter1;
				end if;
				if randomValue < lower_limit then
					randomValue := lower_limit;
				end if;
			algorithm
				when pre(number_request) then
					if distributionSelected == 1 then
					(randomValue, RNGState) := Modelica.Math.Random.Generators.Xorshift1024star.random(RNGState);
					randomValue := randomValue * distributionParameter1 + distributionParameter2;
				elseif distributionSelected == 2 then
					(randomValue, RNGState) := Modelica.Math.Random.Generators.Xorshift1024star.random(RNGState);
					randomValue := -Modelica.Math.log(randomValue) / distributionParameter1;
				else	
					randomValue := distributionParameter1;
				end if;
				if randomValue < lower_limit then
					randomValue := lower_limit;
				end if;
				end when;
			end RandomGenerator;
		  
		end RNG;*/
		
		
		package Generator_PKG
	
			record StateGen
				extends Atomic_PKG.State;
				discrete Real next_TS "Effective time instant of next internal transition";
				discrete Real next_scheduled_generation "Since next_TS is affected by blocking of ports, this variable stores the completion time instant";
				Integer elements_generated "Elements generated by the block";
				Boolean blocked_output "true when OUT.event_request_signal differs from zero, thus output is blocked";
			end StateGen;
			
			record InputVariables_XGen
				extends Atomic_PKG.InputVariables_X;
				parameter Integer n_outputs;
				Boolean port_blocked[n_outputs] "Array that stores information about blockage of output ports (an output port is considered blocked when its request value is different from 0)";
			end InputVariables_XGen;
			
			record OutputVariables_YGen
				extends Atomic_PKG.OutputVariables_Y;
				Integer elements_generated "Elements generated in output";
			end OutputVariables_YGen;
			
			
			
			block Generator "Generator introducing elements in the system"
				extends Atomic_PKG.Atomic(redeclare StateGen S, redeclare InputVariables_XGen X(n_outputs = n_outputs), redeclare OutputVariables_YGen Y, n_inputs = number_inputs, n_outputs = number_outputs, redeclare Boolean external_event[n_outputs]);
				constant Integer batch_dimension = 1 "Elements produced at every generation";
				constant Integer number_inputs = 0 "number of input ports of the system";
				parameter Integer number_outputs = 1 "number of output ports of the system";
				//Random number generation components
				RNG.RandomGenerator RNGBlock(localSeed = localSeed, globalSeed = globalSeed, distributionSelected = distributionSelected, distributionParameter1 = distributionParameter1, distributionParameter2 = distributionParameter2);
				parameter Integer localSeed = 10 "localSeed of the RNG";
				parameter Integer globalSeed = 7 "globalSeed of the RNG";
				parameter Integer distributionSelected = 0 "0 = constant; 1 = uniform; 2 = exponential";
				parameter Real distributionParameter1 = 1;
				parameter Real distributionParameter2 = 0 "used only in uniform distribution to set the bias of the random number";
				parameter Integer elements_to_generate = 4;
				//Block's ports
				Interfaces.Out_Port OUT[n_outputs] annotation(
	          Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
			initial algorithm
				S.next_TS := 0;
				S.next_scheduled_generation := 0;
				S.elements_generated := batch_dimension "The generator starts with an element already produced";
				S.blocked_output := false "at the beginning it is assumed that the output port is free to receive events";
				for i in 1:n_outputs loop
					X.port_blocked[i] := not pre(OUT[i].event_request_signal) == 0;
				end for;
				Y.elements_generated := 0;
				next_TS := S.next_TS;
			algorithm
			//UPDATING next_TS
				when pre(transition_happened) then
					next_TS := S.next_TS "After every transition next_TS equals the value set into the state";
				end when;
			algorithm
				when pre(internal_transition_planned[1]) then
					Y.elements_generated := S.elements_generated "At transition time the number of outputs generated is the number of elements generated according to the state";
				end when;
			///////////////////////////////////////////////////////////////////////
			//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
			///////////////////////////////////////////////////////////////////////
			//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables
			algorithm
				when pre(external_event) then
					for i in 1:n_outputs loop
						X.port_blocked[i] := not pre(OUT[i].event_request_signal) == 0 "If the output port request's values is different from 0 the port is considered blocked";
					end for;
				end when;
			///////////////////////////////////////////////////////////////////////
			//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
			///////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////
			//                        TRANSITIONS CODE                           //
			///////////////////////////////////////////////////////////////////////
			algorithm		
				when pre(confluent_transition) then
				//CONFLUENT TRANSITION CODE
					
					S.blocked_output := false "At the beginning of every transition it is assumed that the output is not blocked, to then check for every port"; 
					for i in 1:n_outputs loop
						if X.port_blocked[i] then
							S.blocked_output := true "If any port is found blocked the whole system considers the output blocked"; 
						end if;
					end for "loop aimed at checking if any of the output ports is considered blocked"; 
					S.next_scheduled_generation := time + RNGBlock.randomValue "In any case, after an internal event the next scheduled generation will take place after timeadvance time";
					RNGBlock.trigger := RNGBlock.trigger + 1 "updating the RNG's trigger with the new transition number informs the RNG that a new random number has to be computed";
					S.elements_generated := S.elements_generated + batch_dimension "the number of elements to be generated is augmented by the output size batch_dimension";
					if S.blocked_output or elements_to_generate < S.elements_generated then
						S.next_TS := Modelica.Constants.inf;
					else
						S.next_TS := S.next_scheduled_generation;
					end if "if any of the output ports are blocked, then the next internal transition is set to infinite, otherwise, it is just the next scheduled one";
				elsewhen pre(external_transition) then
				//EXTERNAL TRANSITION CODE
					
					S.blocked_output := false "At the beginning of every transition it is assumed that the output is not blocked, to then check for every port"; 
					for i in 1:n_outputs loop
						if X.port_blocked[i] then
							S.blocked_output := true "If any port is found blocked the whole system considers the output blocked"; 
						end if;
					end for "loop aimed at checking if any of the output ports is considered blocked"; 
					if S.blocked_output or elements_to_generate < S.elements_generated then
						S.next_TS := Modelica.Constants.inf;
					else
						S.next_TS := S.next_scheduled_generation;
					end if"if any of the output ports are blocked, then the next internal transition is set to infinite, otherwise, it is just the next scheduled one";
					 
				elsewhen pre(internal_transition) then
				//INTERNAL TRANSITION CODE
					
					S.next_scheduled_generation := time + RNGBlock.randomValue "In any case, after an internal event the next scheduled generation will take place after timeadvance time";
					RNGBlock.trigger := RNGBlock.trigger + 1 "updating the RNG's trigger with the new transition number informs the RNG that a new random number has to be computed";
					S.elements_generated := S.elements_generated + batch_dimension "the number of elements to be generated is augmented by the output size batch_dimension";
					if S.blocked_output or elements_to_generate < S.elements_generated then
						S.next_TS := Modelica.Constants.inf;
					else
						S.next_TS := S.next_scheduled_generation;
					end if"if any of the output ports are blocked, then the next internal transition is set to infinite, otherwise, it is just the next scheduled one";
				end when;
			///////////////////////////////////////////////////////////////////////
			//                     END OF TRANSITIONS CODE                       //
			///////////////////////////////////////////////////////////////////////	
			equation
				for i in 1:n_outputs loop
					OUT[i].event_signal = Y.elements_generated;
					external_event[i] = change(OUT[i].event_request_signal);
				end for;
			end Generator;
	  
		end Generator_PKG;
	
	
		package Server_PKG
		  
			record StateSer
				extends Atomic_PKG.State;
				parameter Integer n_inputs;
				discrete Real next_TS"time of next scheduled internal transition";
				Integer elements_processed "Elements successfully processed by the server";			
				Integer request "Requests sent by the server";			
				Boolean active "true if the server is working on a part or not";
				Integer previous_inputs[n_inputs] "Input events at the end of the last transition";
				discrete Real next_scheduled_generation "Since next_TS is affected by blocking of ports, this variable stores the completion time instant";
				Boolean blocked_output "true when IN.event_request_signal differs from zero, thus output is blocked";
				Integer element_arrived_type "integer expressing the type of element arrived depending on the amount of change in the input";
			end StateSer;
			
			record InputVariables_XSer
				extends Atomic_PKG.InputVariables_X;
				parameter Integer n_inputs;
				parameter Integer n_outputs;
				Integer event_trigger[n_inputs] "Events arrived at this event_iteration";
				Boolean port_blocked[n_outputs];
			end InputVariables_XSer;
			
			record OutputVariables_YSer
				extends Atomic_PKG.OutputVariables_Y;
				Integer elements_processed "Elements successfully processed by the server";
				Integer request;
			end OutputVariables_YSer;
			
			record StatisticalRecord
				discrete Real activityPercentage;
				discrete Real activityPercentageOnWIP1;
				discrete Real averageWaitingTime;
				Integer WIP1Received;
				Integer WIP2Received;
				Integer WIP1Sent;
				Integer WIP2Sent;
			end StatisticalRecord;
			
			block Server
				extends Atomic_PKG.Atomic(redeclare StateSer S(n_inputs = n_inputs), redeclare OutputVariables_YSer Y, redeclare InputVariables_XSer X(n_inputs = n_inputs, n_outputs = n_outputs), n_inputs = nInputs, redeclare Boolean external_event[n_inputs + n_outputs], n_outputs = nOutputs);
				constant Integer batch_dimension = 1 "Events given at output once process is finished";
				constant Integer request_dimension = 1 "Events required to start process";
				parameter Boolean convert_event_type = false "if true elements of type 2 arrived in input are processed and exit the server as elements of type 1";
				constant Integer nInputs = 1 "number of input ports of the system";
				constant Integer nOutputs = 1 "number of output ports of the system";
				//Random number generation components
				RNG.RandomGenerator RNGBlock1(localSeed = localSeed, globalSeed = globalSeed, distributionSelected = distributionSelectedEventType1, distributionParameter1 = distributionParameter1EventType1, distributionParameter2 = distributionParameter2EventType1);
				parameter Integer localSeed = 10 "localSeed of the RNG";
				parameter Integer globalSeed = 7 "globalSeed of the RNG";
				parameter Integer distributionSelectedEventType1 = 0 "0 = constant; 1 = uniform; 2 = exponential";
				parameter Real distributionParameter1EventType1 = 1;
				parameter Real distributionParameter2EventType1 = 0 "used only in uniform distribution to set the bias of the random number";
				RNG.RandomGenerator RNGBlock2(localSeed = localSeed, globalSeed = globalSeed, distributionSelected = distributionSelectedEventType2, distributionParameter1 = distributionParameter1EventType2, distributionParameter2 = distributionParameter2EventType2);
				parameter Integer distributionSelectedEventType2 = 0 "0 = constant; 1 = uniform; 2 = exponential";
				parameter Real distributionParameter1EventType2 = 1;
				parameter Real distributionParameter2EventType2 = 0 "used only in uniform distribution to set the bias of the random number";
				StatisticalRecord STATS;
				//Block's ports
				Interfaces.In_Port IN[n_inputs] annotation(
	          Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
				Interfaces.Out_Port OUT[n_outputs] annotation(
	          Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
			initial algorithm
				S.next_TS := 0 "the next internal transition is scheduled at time 0 to send a request";
				S.request := request_dimension "the beginning request to be sent is equal to the amount of entities required to start a process, in this case always 1";
				S.active := false "server starts idle";
				for i in 1:n_inputs loop
					S.previous_inputs[i] := 0;
				end for;
				S.elements_processed := 0 "server starts with no elements processed";
				Y.elements_processed := S.elements_processed;
				Y.request := 0;
				for i in 1:n_inputs loop
					X.event_trigger[i] := pre(IN[i].event_signal);
				end for;
				for i in 1:n_outputs loop
					X.port_blocked[i] := not pre(OUT[i].event_request_signal) == 0;
				end for;
				S.blocked_output := false; 
				for i in 1:n_outputs loop
					if X.port_blocked[i] then
						S.blocked_output := true; 
					end if;
				end for;
				next_TS := S.next_TS;
			algorithm
			//UPDATING next_TS
				when pre(transition_happened) then
					next_TS := S.next_TS "After every transition next_TS equals the value set into the state";
				end when;
			algorithm
				when pre(internal_transition_planned[1]) then //MAYBE A pre() HERE SHOULD PUT TOO
					Y.elements_processed := S.elements_processed;
					Y.request := S.request;
				end when;
			///////////////////////////////////////////////////////////////////////
			//                        TRANSITIONS CODE                           //
			///////////////////////////////////////////////////////////////////////
			algorithm
				when pre(confluent_transition) then
				//CONFLUENT TRANSITION CODE
				
					if S.active then
						STATS.activityPercentage := (STATS.activityPercentage * (time - elapsed_time) + elapsed_time * 100) / time;
						if S.element_arrived_type == 1 then
							STATS.activityPercentageOnWIP1 := (STATS.activityPercentageOnWIP1 * (time - elapsed_time) + elapsed_time * 100) / time;
						else
							STATS.activityPercentageOnWIP1  := (STATS.activityPercentageOnWIP1 * (time - elapsed_time)) / time;
						end if;
					else
						STATS.activityPercentage := (STATS.activityPercentage * (time - elapsed_time)) / time;
						STATS.activityPercentageOnWIP1  := (STATS.activityPercentageOnWIP1 * (time - elapsed_time)) / time;
					end if;
					
					S.blocked_output := false "At the beginning of every transition it is assumed that the output is not blocked, to then check for every port"; 
					for i in 1:n_outputs loop
						if X.port_blocked[i] then
							S.blocked_output := true "If any port is found blocked the whole system considers the output blocked"; 
						end if;
					end for "loop aimed at checking if any of the output ports is considered blocked"; 
					
					if S.active then
						S.active := false;
						if convert_event_type then
							S.elements_processed := S.elements_processed + 1 "at next internal transition elements processed will be augmented";
						else
							S.elements_processed := S.elements_processed + S.element_arrived_type "at next internal transition elements processed will be augmented";
						end if;
						S.request := S.request + request_dimension "at next internal transition the request will be augmented";
						S.element_arrived_type := 0;
						S.next_scheduled_generation := Functions.ImmediateInternalTransition(S.next_scheduled_generation);
					else
						S.next_scheduled_generation := Modelica.Constants.inf;
					end if; 
					
					for i in 1:n_inputs loop
						S.element_arrived_type := X.event_trigger[i] - S.previous_inputs[i];
						S.previous_inputs[i] := X.event_trigger[i] "at the next transition previous input elements will be equal to the actual ones";
						if S.element_arrived_type == 1 then
							STATS.WIP1Received := STATS.WIP1Received + 1;
						elseif S.element_arrived_type == 2 then
							STATS.WIP2Received := STATS.WIP2Received + 1;
						end if;
					end for "for loop to acquire arrived event"; 
					
					if S.element_arrived_type == 1 then
						S.next_scheduled_generation := time + RNGBlock1.randomValue "the next process is scheduled to be finished at the actual time plus the parameter time advance";
						RNGBlock1.trigger := RNGBlock1.trigger + 1 "updating the RNG's trigger with the new transition number informs the RNG that a new random number has to be computed";
						S.active := true "starting a process the server turns to active";
						/*S.elements_processed := S.elements_processed + 1 "at next internal transition elements processed will be augmented";
						S.request := S.request + request_dimension "at next internal transition the request will be augmented";*/
					elseif S.element_arrived_type == 2 then
						S.next_scheduled_generation := time + RNGBlock2.randomValue "the next process is scheduled to be finished at the actual time plus the parameter time advance";
						RNGBlock2.trigger := RNGBlock2.trigger + 1 "updating the RNG's trigger with the new transition number informs the RNG that a new random number has to be computed";
						S.active := true "starting a process the server turns to active";
						/*if convert_event_type then
							S.elements_processed := S.elements_processed + 1 "at next internal transition elements processed will be augmented";
						else
							S.elements_processed := S.elements_processed + 2 "at next internal transition elements processed will be augmented";
						end if "if aimed at checking if the server is allowed to convert a type 2 event into a type 1";
						S.request := S.request + request_dimension "at next internal transition the request will be augmented";*/
					end if;
					
					if S.active then
						S.next_TS := S.next_scheduled_generation;
					elseif S.blocked_output then
						S.next_TS := Modelica.Constants.inf "in any case, if output ports are blocked next internal transition is scheduled at infinite time";
					else
						S.next_TS := S.next_scheduled_generation;
					end if "if to evaluate next_TS in relation to the output being blocked";
				elsewhen pre(external_transition) then
				//EXTERNAL TRANSITION CODE
				
					if S.active then
						STATS.activityPercentage := (STATS.activityPercentage * (time - elapsed_time) + elapsed_time * 100) / time;
						if S.element_arrived_type == 1 then
							STATS.activityPercentageOnWIP1 := (STATS.activityPercentageOnWIP1 * (time - elapsed_time) + elapsed_time * 100) / time;
						else
							STATS.activityPercentageOnWIP1  := (STATS.activityPercentageOnWIP1 * (time - elapsed_time)) / time;
						end if;
					else
						STATS.activityPercentage := (STATS.activityPercentage * (time - elapsed_time)) / time;
						STATS.activityPercentageOnWIP1  := (STATS.activityPercentageOnWIP1 * (time - elapsed_time)) / time;
					end if;
					
					S.blocked_output := false "At the beginning of every transition it is assumed that the output is not blocked, to then check for every port"; 
					for i in 1:n_outputs loop
						if X.port_blocked[i] then
							S.blocked_output := true "If any port is found blocked the whole system considers the output blocked"; 
						end if;
					end for "loop aimed at checking if any of the output ports is considered blocked"; 
					
					if not S.active then
					
						for i in 1:n_inputs loop
							S.element_arrived_type := X.event_trigger[i] - S.previous_inputs[i];
							S.previous_inputs[i] := X.event_trigger[i] "at the next transition previous input elements will be equal to the actual ones";
							if S.element_arrived_type == 1 then
								STATS.WIP1Received := STATS.WIP1Received + 1;
							elseif S.element_arrived_type == 2 then
								STATS.WIP2Received := STATS.WIP2Received + 1;
							end if;
						end for "for loop to acquire arrived event";  
					
						if S.element_arrived_type == 1 then
							S.next_scheduled_generation := time + RNGBlock1.randomValue "the next process is scheduled to be finished at the actual time plus the parameter time advance";
							RNGBlock1.trigger := RNGBlock1.trigger + 1 "updating the RNG's trigger with the new transition number informs the RNG that a new random number has to be computed";
							S.active := true "starting a process the server turns to active";
						/*S.elements_processed := S.elements_processed + 1 "at next internal transition elements processed will be augmented";
						S.request := S.request + request_dimension "at next internal transition the request will be augmented";*/
						elseif S.element_arrived_type == 2 then
							S.next_scheduled_generation := time + RNGBlock2.randomValue "the next process is scheduled to be finished at the actual time plus the parameter time advance";
							RNGBlock2.trigger := RNGBlock2.trigger + 1 "updating the RNG's trigger with the new transition number informs the RNG that a new random number has to be computed";
							S.active := true "starting a process the server turns to active";
						/*if convert_event_type then
							S.elements_processed := S.elements_processed + 1 "at next internal transition elements processed will be augmented";
						else
							S.elements_processed := S.elements_processed + 2 "at next internal transition elements processed will be augmented";
						end if "if aimed at checking if the server is allowed to convert a type 2 event into a type 1";
						S.request := S.request + request_dimension "at next internal transition the request will be augmented";*/
						end if;
					end if;
					
					if not S.blocked_output and S.next_scheduled_generation <= time then
							STATS.averageWaitingTime := (STATS.averageWaitingTime * (STATS.WIP1Sent + STATS.WIP2Sent) + (elapsed_time)) / (STATS.WIP1Sent + STATS.WIP2Sent + 1);
					end if;
					
					if S.active then
						S.next_TS := S.next_scheduled_generation;
					elseif S.blocked_output then
						S.next_TS := Modelica.Constants.inf "in any case, if output ports are blocked next internal transition is scheduled at infinite time";
					else
						S.next_TS := S.next_scheduled_generation;
					end if "if to evaluate next_TS in relation to the output being blocked";
				elsewhen pre(internal_transition) then
				//INTERNAL TRANSITION CODE
				
					if S.active then
						STATS.activityPercentage := (STATS.activityPercentage * (time - elapsed_time) + elapsed_time * 100) / time;
						if S.element_arrived_type == 1 then
							STATS.activityPercentageOnWIP1 := (STATS.activityPercentageOnWIP1 * (time - elapsed_time) + elapsed_time * 100) / time;
						else
							STATS.activityPercentageOnWIP1  := (STATS.activityPercentageOnWIP1 * (time - elapsed_time)) / time;
						end if;
					else
						STATS.activityPercentage := (STATS.activityPercentage * (time - elapsed_time)) / time;
						STATS.activityPercentageOnWIP1  := (STATS.activityPercentageOnWIP1 * (time - elapsed_time)) / time;
					end if;
					
					if S.active then
						S.active := false;
						
						if not S.blocked_output then
							STATS.averageWaitingTime := (STATS.averageWaitingTime * (STATS.WIP1Sent + STATS.WIP2Sent) + (0)) / (STATS.WIP1Sent + STATS.WIP2Sent + 1);
						end if;
						
						if convert_event_type then
							S.elements_processed := S.elements_processed + 1 "at next internal transition elements processed will be augmented";
							STATS.WIP1Sent := STATS.WIP1Sent + 1;
						else
							S.elements_processed := S.elements_processed + S.element_arrived_type "at next internal transition elements processed will be augmented";
							
							if S.element_arrived_type == 1 then
								STATS.WIP1Sent := STATS.WIP1Sent + 1;
							elseif S.element_arrived_type == 2 then
								STATS.WIP2Sent := STATS.WIP2Sent + 1;
							end if;
						end if;
						
						S.request := S.request + request_dimension "at next internal transition the request will be augmented";
						S.element_arrived_type := 0;
						S.next_scheduled_generation := Functions.ImmediateInternalTransition(S.next_scheduled_generation);
					else
						S.next_scheduled_generation := Modelica.Constants.inf;
					end if;
					
					if S.blocked_output then
						S.next_TS := Modelica.Constants.inf "in any case, if output ports are blocked next internal transition is scheduled at infinite time";
					else
						S.next_TS := S.next_scheduled_generation;
					end if "if to evaluate next_TS in relation to the output being blocked";
				end when;	
			///////////////////////////////////////////////////////////////////////
			//                     END OF TRANSITIONS CODE                       //
			///////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////
			//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
			///////////////////////////////////////////////////////////////////////
			//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables
			algorithm
				when pre(external_event) then
					for i in 1:n_inputs loop
						X.event_trigger[i] := pre(IN[i].event_signal);
					end for;
					for i in 1:n_outputs loop
						X.port_blocked[i] := not pre(OUT[i].event_request_signal) == 0 "If the output port request's values is different from 0 the port is considered blocked";
					end for;
				end when;
			///////////////////////////////////////////////////////////////////////
			//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
			///////////////////////////////////////////////////////////////////////
			equation
				for i in 1:n_outputs loop
					OUT[i].event_signal = Y.elements_processed;
					external_event[i + n_inputs] = change(OUT[i].event_request_signal);
				end for;
				for i in 1:n_inputs loop
					IN[i].event_request_signal = Y.request;
					external_event[i] = change(IN[i].event_signal);
				end for;
			end Server;
		  
		end Server_PKG;
	
	
	
		package DelayedQueue_PKG
		
			record StateDlq
				extends Atomic_PKG.State;
				parameter Integer n_inputs;
				parameter Integer capacity "amount of elements that can be delayed at the same time";
				discrete Real next_TS;
				discrete Real next_TS_array[capacity + 2*n_inputs] "array containing availability times for elements arrived at the queue";
				Integer element_types[capacity + 2*n_inputs] "array containing the types of elementes in the queue";
				Integer previous_inputs[n_inputs] "Input events at the end of the last transition";		
				Integer elements_sent "elements already sent out of output ports";
				Integer previous_request "value of requests arrived at the last transition from input ports";
				Boolean pending_request "true if a request is awaiting to be satisfied for the input port";
				Integer elements_waiting "elements inside the delay block";
				Integer element_to_be_sent "value of the element that will be sent at the next internal transition";
				Integer elements_discarded "elements that the block is not able to hold and that it discards out of the system";
				Boolean immediate_transition_required "used to indicate that an internal transition has to be fired immediately to change settings in the input";
				Boolean blocking_input "true if input has to be blocked";
			end StateDlq;
			
			record InputVariables_XDlq
				extends Atomic_PKG.InputVariables_X;
				parameter Integer n_inputs;
				Integer event_trigger[n_inputs] "number of elements arrived in input";
				Integer request_trigger;
			end InputVariables_XDlq;
			
			record OutputVariables_YDlq
				extends Atomic_PKG.OutputVariables_Y;
				Integer elements_sent;
				Integer input_ports_value "used to communicate to the inputs the the queue is full and no more elements can be sent";
			end OutputVariables_YDlq;
			
			record StatisticalRecord
				discrete Real averageWaitingTime;
				Integer WIP1Sent;
				Integer WIP2Sent;
			end StatisticalRecord;
			
			block DelayedQueue
				extends Atomic_PKG.Atomic(redeclare StateDlq S(capacity = capacity, n_inputs = n_inputs), redeclare OutputVariables_YDlq Y, redeclare InputVariables_XDlq X(n_inputs = n_inputs), n_inputs = nInputs, redeclare Boolean external_event[n_inputs + n_outputs], n_outputs = nOutputs);
				parameter Integer nInputs = 1 "number of input ports of the system";
				constant Integer nOutputs = 1 "number of output ports of the system";			
				parameter Integer capacity = 1 "amount of elements the queue can store";
				parameter Boolean allow_elements_in_excess = true "If true, when elements surpassing the capacity arrive, they are retained if less than the twice the number of inputs. If false, elements in excess are discarded";
				//Random number generation components
				RNG.RandomGenerator RNGBlock(localSeed = localSeed, globalSeed = globalSeed, distributionSelected = distributionSelected, distributionParameter1 = distributionParameter1, distributionParameter2 = distributionParameter2);
				parameter Integer localSeed = 10 "localSeed of the RNG";
				parameter Integer globalSeed = 7 "globalSeed of the RNG";
				parameter Integer distributionSelected = 0 "0 = constant; 1 = uniform; 2 = exponential";
				parameter Real distributionParameter1 = 1;
				parameter Real distributionParameter2 = 0 "used only in uniform distribution to set the bias of the random number";
				StatisticalRecord STATS;
				//Block's ports
				Interfaces.In_Port IN[n_inputs] annotation(
	          Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
				Interfaces.Out_Port OUT[n_outputs] annotation(
	          Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
			initial algorithm
				S.elements_waiting := 0;
				S.elements_sent := 0;
				S.element_to_be_sent := 0;			
				for i in 1:size(S.next_TS_array, 1) loop
					S.next_TS_array[i] := Modelica.Constants.inf;
					S.element_types[i] := 0;
				end for "If there's no element in the queue, at its corimmediate_transition_required place there is a type zero (non-existing) element and a next avalability at infinite. At the beginning the queue is empty";
				S.next_TS := Modelica.Constants.inf;
				next_TS := S.next_TS;
				S.blocking_input := S.elements_waiting >= capacity;
				S.immediate_transition_required :=false;
				for i in 1:n_inputs loop
					S.previous_inputs[i] := 0;
				end for;
			algorithm
			//UPDATING next_TS
				when pre(transition_happened) then
					next_TS := S.next_TS "After every transition next_TS equals the value set into the state";
				end when;
			algorithm
				when pre(internal_transition_planned[1]) then
					for i in 1:n_outputs loop
						Y.elements_sent := S.elements_sent + S.element_to_be_sent "After an internal event the elements in output are the sum of the elemennts already sent and the elements to be sent at the last transition";
					end for;
					if S.blocking_input then
						Y.input_ports_value := -1;
					else
						Y.input_ports_value := 0;
					end if "If output ports are set ot  be blocked then request value is set to -1, otherwise 0";
				end when;
			///////////////////////////////////////////////////////////////////////
			//                        TRANSITIONS CODE                           //
			///////////////////////////////////////////////////////////////////////
			algorithm
				when pre(confluent_transition) then
				//CONFLUENT TRANSITION CODE
				
					if S.element_to_be_sent > 0 then
					
						STATS.averageWaitingTime := (STATS.averageWaitingTime * (STATS.WIP1Sent + STATS.WIP2Sent) + (time - S.next_TS_array[1])) / (STATS.WIP1Sent + STATS.WIP2Sent + 1);
					
						if S.element_to_be_sent == 1 then
							STATS.WIP1Sent := STATS.WIP1Sent + 1;
						elseif S.element_to_be_sent == 2 then
							STATS.WIP2Sent := STATS.WIP2Sent + 1;
						end if;
					end if;
					
					if S.element_to_be_sent > 0 then //If at the last transition an element has been sent
						S.pending_request := false "in case an element has been sent the pending request has been satisfied";						
						S.elements_sent := S.elements_sent + S.element_to_be_sent "after every internal transition update the amount of elements already sent is augmented to keep track of the last sending";
						S.elements_waiting := S.elements_waiting - 1 "an element is removed from the queue";
						S.element_to_be_sent := 0;
						for i in 1:S.elements_waiting loop
							S.next_TS_array[i] := S.next_TS_array[i + 1];
							S.element_types[i] := S.element_types[i + 1];
						end for "for loop used to move by one position the elements of queue's arrays";
						S.next_TS_array[S.elements_waiting + 1] := Modelica.Constants.inf;
						S.element_types[S.elements_waiting + 1] := 0 "in place of the last element the end of the queue a non existing element is placed";			
					end if "if at the last transition an element have been sent, remove it from the queue";
					for i in 1:n_inputs loop
						if X.event_trigger[i] - S.previous_inputs[i] > 0 then
							if allow_elements_in_excess and S.elements_waiting < size(S.next_TS_array, 1) and S.elements_waiting < size(S.element_types, 1) then
								S.elements_waiting := S.elements_waiting + 1;
								S.next_TS_array[S.elements_waiting] := time + RNGBlock.randomValue;
								S.element_types[S.elements_waiting] := X.event_trigger[i] - S.previous_inputs[i];
								S.previous_inputs[i] := X.event_trigger[i] "at the next transition the previous inputs will be equal to the actual ones";	
							elseif not allow_elements_in_excess and S.elements_waiting < capacity then
								S.elements_waiting := S.elements_waiting + 1;
								S.next_TS_array[S.elements_waiting] := time + RNGBlock.randomValue;
								S.element_types[S.elements_waiting] := X.event_trigger[i] - S.previous_inputs[i];
								S.previous_inputs[i] := X.event_trigger[i] "at the next transition the previous inputs will be equal to the actual ones";	
							else
								S.previous_inputs[i] := X.event_trigger[i] "at the next transition the previous inputs will be equal to the actual ones";	
								S.elements_discarded := S.elements_discarded + 1;
							end if;			
						end if;
					end for "Cicle aimed at acquiring new elements";
					RNGBlock.trigger := RNGBlock.trigger + 1 "updating the RNG's trigger with the new transition number informs the RNG that a new random number has to be computed";
					//Checking if new request is present
					if X.request_trigger > S.previous_request then //If the input request trigger surpasses the old one, a new request has been sent to the queue
						S.pending_request := true;
						S.previous_request := X.request_trigger "at the next transition the previous requests will be equal to the actual ones";
					end if;
					S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
					if S.elements_waiting >= capacity and not S.blocking_input then //In case the queue contains more elements than allowed and the input ports are not blocked, then block them immediately by setting immediate_transition_required to true
						S.blocking_input := true;
						S.immediate_transition_required := true;
						S.element_to_be_sent := 0 "in case an internal transition has to fired immediately, don't send anything";
					elseif S.elements_waiting < capacity and S.blocking_input then //In case the port was locked but there is room for elements, unlock the inputs immediately by setting immediate_transition_required to true
						S.blocking_input := false;
						S.immediate_transition_required := true;
						S.element_to_be_sent := 0 "in case an internal transition has to fired immediately, don't send anything";
					end if "if branch used to handle the blocking of input ports";
					if S.pending_request and S.next_TS_array[1] <= time then //If there is a pending request that can be already satisfied, satisty it immediately by setting immediate_transition_required to true
						S.element_to_be_sent := S.element_types[1] "the element to be sent is the first ready to be sent";
						S.immediate_transition_required := true;
						if S.elements_waiting <= capacity then
							S.blocking_input := false;
						end if "if the capacity is equal to the elements inside the queue, at the next transition th input ports wll be unlocked";
					end if;
					if S.immediate_transition_required then
						S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "in case an immediate response is required, an apposite function manipulates next_TS to trigger it directly inside the event iteration without waiting for simulation time";
					elseif S.pending_request then //if there is a pending request, satisfy it with the next element in line
						S.next_TS := S.next_TS_array[1] ;
						S.element_to_be_sent := S.element_types[1];
						if S.elements_waiting <= capacity then
							S.blocking_input := false;
						end if "if the capacity is equal to the elements inside the queue, at the next transition, after the sending, the input ports wll be unlocked";
					else
						S.next_TS := Modelica.Constants.inf "without requests or responses to be ginven the queue stays idle";
					end if;		
				elsewhen pre(external_transition) then
				//EXTERNAL TRANSITION CODE
					
					for i in 1:n_inputs loop
						if X.event_trigger[i] - S.previous_inputs[i] > 0 then
							if allow_elements_in_excess and S.elements_waiting < size(S.next_TS_array, 1) and S.elements_waiting < size(S.element_types, 1) then
								S.elements_waiting := S.elements_waiting + 1;
								S.next_TS_array[S.elements_waiting] := time + RNGBlock.randomValue;
								S.element_types[S.elements_waiting] := X.event_trigger[i] - S.previous_inputs[i];
								S.previous_inputs[i] := X.event_trigger[i] "at the next transition the previous inputs will be equal to the actual ones";	
							elseif not allow_elements_in_excess and S.elements_waiting < capacity then
								S.elements_waiting := S.elements_waiting + 1;
								S.next_TS_array[S.elements_waiting] := time + RNGBlock.randomValue;
								S.element_types[S.elements_waiting] := X.event_trigger[i] - S.previous_inputs[i];
								S.previous_inputs[i] := X.event_trigger[i] "at the next transition the previous inputs will be equal to the actual ones";	
							else
								S.previous_inputs[i] := X.event_trigger[i] "at the next transition the previous inputs will be equal to the actual ones";	
								S.elements_discarded := S.elements_discarded + 1;
							end if;			
						end if;
					end for "Cicle aimed at acquiring new elements, due to the application of the block, no check on excess of capacity is conducted";
					RNGBlock.trigger := RNGBlock.trigger + 1 "updating the RNG's trigger with the new transition number informs the RNG that a new random number has to be computed";
					//Checking if new request is present
					if X.request_trigger > S.previous_request then
						S.pending_request := true;
						S.previous_request := X.request_trigger "at the next transition the previous requests will be equal to the actual ones";
					end if;
					S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
					if S.elements_waiting >= capacity and not S.blocking_input then //In case the queue contains more elements than allowed and the input ports are not blocked, then block them immediately by setting immediate_transition_required to true
						S.blocking_input := true;
						S.immediate_transition_required := true;
						S.element_to_be_sent := 0 "in case an internal transition has to fired immediately, don't send anything";
					elseif S.elements_waiting < capacity and S.blocking_input then //In case the port was locked but there is room for elements, unlock the inputs immediately by setting response to true
						S.blocking_input := false;
						S.immediate_transition_required := true;
						S.element_to_be_sent := 0 "in case an internal transition has to fired immediately, don't send anything";
					end if "if branch used to handle the blocking of input ports";
					if S.pending_request and S.next_TS_array[1] <= time then //If there is a pending request that can be already satisfied, satisty it immediately by setting immediate_transition_required to true
						S.element_to_be_sent := S.element_types[1] "the element to be sent is the first ready to be sent";
						S.immediate_transition_required := true;
						if S.elements_waiting <= capacity then
							S.blocking_input := false;
						end if "if the capacity is equal to the elements inside the queue, at the next transition, after the sending, the input ports wll be unlocked";
					end if;
					if S.immediate_transition_required then
						S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "in case an immediate response is required, an apposite function manipulates next_TS to trigger it directly inside the event iteration without waiting for simulation time";
					elseif S.pending_request then //if there is a pending request, satisfy it with the next element in line
						S.next_TS := S.next_TS_array[1] ;
						S.element_to_be_sent := S.element_types[1];
						if S.elements_waiting <= capacity then
							S.blocking_input := false;
						end if "if the capacity is equal to the elements inside the queue, at the next transition, after the sending, the input ports wll be unlocked";
					else
						S.next_TS := Modelica.Constants.inf "without requests or responses to be ginven the queue stays idle";
					end if;			
				elsewhen pre(internal_transition) then
				//INTERNAL TRANSITION CODE
				
					if S.element_to_be_sent > 0 then
					
						STATS.averageWaitingTime := (STATS.averageWaitingTime * (STATS.WIP1Sent + STATS.WIP2Sent) + (time - S.next_TS_array[1])) / (STATS.WIP1Sent + STATS.WIP2Sent + 1);
					
						if S.element_to_be_sent == 1 then
							STATS.WIP1Sent := STATS.WIP1Sent + 1;
						elseif S.element_to_be_sent == 2 then
							STATS.WIP2Sent := STATS.WIP2Sent + 1;
						end if;
					end if;
					
					if S.element_to_be_sent > 0 then //If at the last transition an element has been sent
						S.pending_request := false "in case an element has been sent the pending request has been satisfied";
						S.elements_sent := S.elements_sent + S.element_to_be_sent "after every internal transition update the amount of elements already sent is augmented to keep track of the last sending";
						S.elements_waiting := S.elements_waiting - 1 "an element is removed from the queue";
						S.element_to_be_sent := 0;
						for i in 1:S.elements_waiting loop
							S.next_TS_array[i] := S.next_TS_array[i + 1];
							S.element_types[i] := S.element_types[i + 1];
						end for "for loop used to move by one position the elements of queue's arrays";
						S.next_TS_array[S.elements_waiting + 1] := Modelica.Constants.inf;
						S.element_types[S.elements_waiting + 1] := 0 "in place of the last element the end of the queue a non existing element is placed";			
					end if "if at the last transition an element have been sent, remove it from the queue";
					S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
					if S.elements_waiting >= capacity and not S.blocking_input then //In case the queue contains more elements than allowed and the input ports are not blocked, then block them immediately by setting immediate_transition_required to true
						S.blocking_input := true;
						S.immediate_transition_required := true;
						S.element_to_be_sent := 0 "in case an internal transition has to fired immediately, don't send anything";
					elseif S.elements_waiting < capacity and S.blocking_input then //In case the port was locked but there is room for elements, unlock the inputs immediately by setting response to true
						S.blocking_input := false;
						S.immediate_transition_required := true;
						S.element_to_be_sent := 0 "in case an internal transition has to fired immediately, don't send anything";
					end if "if branch used to handle the blocking of input ports";
					if S.immediate_transition_required then
						S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "in case an immediate response is required, an apposite function manipulates next_TS to trigger it directly inside the event iteration without waiting for simulation time";
					elseif S.pending_request then //if there is a pending request, satisfy it with the next element in line
						S.next_TS := S.next_TS_array[1] ;
						S.element_to_be_sent := S.element_types[1];
						if S.elements_waiting <= capacity then
							S.blocking_input := false;
						end if "if the capacity is equal to the elements inside the queue, at the next transition, after the sending, the input ports wll be unlocked";
					else
						S.next_TS := Modelica.Constants.inf "without requests or responses to be ginven the queue stays idle";
					end if;
				end when;
			///////////////////////////////////////////////////////////////////////
			//                     END OF TRANSITIONS CODE                       //
			///////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////
			//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
			///////////////////////////////////////////////////////////////////////
			//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables	
			algorithm
				when pre(external_event) then
					for i in 1:n_inputs loop					
						X.event_trigger[i] := pre(IN[i].event_signal);
					end for;
					for i in 1:n_outputs loop
						X.request_trigger := pre(OUT[i].event_request_signal);
					end for;
				end when;
			///////////////////////////////////////////////////////////////////////
			//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
			///////////////////////////////////////////////////////////////////////
			equation
				for i in 1:n_inputs loop
					external_event[i] = change(IN[i].event_signal);
					IN[i].event_request_signal = Y.input_ports_value;
				end for;
				for i in 1:n_outputs loop
					OUT[i].event_signal = Y.elements_sent;
					external_event[n_inputs + i] = change(OUT[i].event_request_signal);
				end for;
			end DelayedQueue;
		  
		end DelayedQueue_PKG;
		
		
		
		package TwoWayQueue_PKG "Special delay queue that, in case capacity is exceeded, sends the events in excess through the RELIEF port as elements of type 2"
		  
			record StateTwq
				extends Atomic_PKG.State;
				parameter Integer n_inputs;
				parameter Integer capacity "amount of elements that can be delayed at the same time";
				discrete Real next_TS;
				discrete Real next_TS_array[capacity] "array containing availability times for elements arrived at the queue";
				Integer element_types[capacity] "array containing the types of elementes in the queue";
				Integer previous_inputs[n_inputs] "Input events at the end of the last transition";		
				Integer elements_sent "elements sent out of output ports";
				Integer relief_elements_sent "relief elements to be sent out of output ports";
				Integer previous_request "value of requests arrived at the last transition from input ports";
				Boolean pending_request "requests awaiting to be satisfied for every input port";
				Integer elements_waiting "elements insde the delay block";
				Integer element_to_be_sent "amount of elements that are sent at transition";
				Boolean immediate_transition_required "used to indicate that an internal transition has to be fired immediately to change settings in the input";
				//Boolean sending_relief_element "true when capacity is excessed and an element has to be sent out of the relief port";
			end StateTwq;
			
			record InputVariables_XTwq
				extends Atomic_PKG.InputVariables_X;
				parameter Integer n_inputs;
				Integer event_trigger[n_inputs] "number of elements arrived in input";
				Integer request_trigger;
			end InputVariables_XTwq;
			
			record OutputVariables_YTwq
				extends Atomic_PKG.OutputVariables_Y;
				Integer elements_sent;
				Integer relief_elements_sent;
				Integer input_ports_value;
			end OutputVariables_YTwq;
			
			record StatisticalRecord
				discrete Real averageWaitingTime;
				discrete Real averageWIPs1InPlant;
				discrete Real averageWIPs2InPlant;
				Integer WIP1Sent;
				Integer WIP2Sent;
				Integer WIP1InPlant;
				Integer WIP2InPlant;
			end StatisticalRecord;
			
			block TwoWayQueue "Delayed queue with no attribute blocking ports. When queue is full and a new element arrives, the element is sent out of the relief the port with a specific value"
				extends Atomic_PKG.Atomic(redeclare StateTwq S(capacity = capacity, n_inputs = n_inputs), redeclare OutputVariables_YTwq Y, redeclare InputVariables_XTwq X(n_inputs = n_inputs), n_inputs = nInputs, redeclare Boolean external_event[n_inputs + n_outputs], n_outputs = nOutputs);
				constant Integer nInputs = 1 "number of input ports of the system";
				constant Integer nOutputs = 1 "number of output ports of the system";			
				parameter Integer capacity = 1 "amount of elements the queue can store";
				parameter Integer relief_specific_value = 2 "value to be given in output at every new value out of the RELIEF port";
				//Random number generation components
				RNG.RandomGenerator RNGBlock(localSeed = localSeed, globalSeed = globalSeed, distributionSelected = distributionSelected, distributionParameter1 = distributionParameter1, distributionParameter2 = distributionParameter2);
				parameter Integer localSeed = 10 "localSeed of the RNG";
				parameter Integer globalSeed = 7 "globalSeed of the RNG";
				parameter Integer distributionSelected = 0 "0 = constant; 1 = uniform; 2 = exponential";
				parameter Real distributionParameter1 = 1;
				parameter Real distributionParameter2 = 0 "used only in uniform distribution to set the bias of the random number";
				parameter Integer carriersInPlant;
				StatisticalRecord STATS;
				//Block's ports
				Interfaces.In_Port IN[n_inputs] annotation(
	          Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
				Interfaces.Out_Port OUT[n_outputs] annotation(
	          Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
				Interfaces.Out_Port RELIEF[n_outputs] annotation(
	          Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, 70}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
			initial algorithm
				S.elements_waiting := 0;
				S.elements_sent := 0;
				S.element_to_be_sent := 0;			
				for i in 1:capacity loop
					S.next_TS_array[i] := Modelica.Constants.inf;
					S.element_types[i] := 0;
				end for;
				S.next_TS := Modelica.Constants.inf;
				next_TS := S.next_TS;
				S.immediate_transition_required :=false;
				S.previous_request := 0;
				for i in 1:n_inputs loop
					S.previous_inputs[i] := 0;
				end for;
				STATS.WIP1InPlant := carriersInPlant;
				STATS.WIP2InPlant := 0;
			algorithm
			//UPDATING next_TS
				when pre(transition_happened) then
					next_TS := S.next_TS "After every transition next_TS equals the value set into the state";
				end when;
			algorithm
				when pre(internal_transition_planned[1]) then
					for i in 1:n_outputs loop
						Y.elements_sent := S.elements_sent + S.element_to_be_sent;
						Y.relief_elements_sent := S.relief_elements_sent;
					end for;
					Y.input_ports_value := 0 "input ports are always unlocked";
				end when;
			///////////////////////////////////////////////////////////////////////
			//                        TRANSITIONS CODE                           //
			///////////////////////////////////////////////////////////////////////
			algorithm
				when pre(confluent_transition) then
				//CONFLUENT TRANSITION CODE
				
					STATS.averageWIPs1InPlant := (STATS.averageWIPs1InPlant * (time - elapsed_time) + STATS.WIP1InPlant * elapsed_time) / time;
					STATS.averageWIPs2InPlant := (STATS.averageWIPs2InPlant * (time - elapsed_time) + STATS.WIP2InPlant * elapsed_time) / time;
				
					if S.element_to_be_sent > 0 then
					
						STATS.averageWaitingTime := (STATS.averageWaitingTime * (STATS.WIP1Sent + STATS.WIP2Sent) + (time - S.next_TS_array[1])) / (STATS.WIP1Sent + STATS.WIP2Sent + 1);
					
						if S.element_to_be_sent == 1 then
							STATS.WIP1Sent := STATS.WIP1Sent + 1;
						elseif S.element_to_be_sent == 2 then
							STATS.WIP2Sent := STATS.WIP2Sent + 1;
						end if;
					end if;
					
					S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
					if S.element_to_be_sent > 0 then
						S.pending_request := false;
						S.elements_sent := S.elements_sent + S.element_to_be_sent "after every internal transition update the amount of elements already sent";
						S.elements_waiting := S.elements_waiting - 1;
						S.element_to_be_sent := 0;
						for i in 1:S.elements_waiting loop
							S.next_TS_array[i] := S.next_TS_array[i + 1];
							S.element_types[i] := S.element_types[i + 1];
						end for;
						if S.elements_waiting + 1 <= size(S.next_TS_array, 1) and S.elements_waiting + 1 <= size(S.element_types, 1) then
							S.next_TS_array[S.elements_waiting + 1] := Modelica.Constants.inf;
							S.element_types[S.elements_waiting + 1] := 0;		
						end if;	
					end if "if at the last transition an element has been sent, remove it from the queue";
					for i in 1:n_inputs loop
						if X.event_trigger[i] - S.previous_inputs[i] > 0 then
							if S.elements_waiting < capacity then
								S.elements_waiting := S.elements_waiting + 1;
								S.next_TS_array[S.elements_waiting] := time + RNGBlock.randomValue;
								S.element_types[S.elements_waiting] := X.event_trigger[i] - S.previous_inputs[i];
								if X.event_trigger[i] - S.previous_inputs[i] == 2 then
									STATS.WIP1InPlant := STATS.WIP1InPlant + 1;
									STATS.WIP2InPlant := STATS.WIP2InPlant - 1;
								end if;
								S.previous_inputs[i] := X.event_trigger[i] "at the next transition the previous inputs will be equal to the actual ones";
							else //if an event is acquired and the capacity is exceeded then a relief event is sent immediately
								S.immediate_transition_required := true;
								S.relief_elements_sent := S.relief_elements_sent + relief_specific_value;
								
								if X.event_trigger[i] - S.previous_inputs[i] == 1 then
									STATS.WIP1InPlant := STATS.WIP1InPlant - 1;
									STATS.WIP2InPlant := STATS.WIP2InPlant + 1;
								end if;
								
								S.previous_inputs[i] := X.event_trigger[i] "at the next transition the previous inputs will be equal to the actual ones";
								S.element_to_be_sent := 0;
							end if;		
						end if;
					end for "Cicle aimed at acquiring new elements";
					RNGBlock.trigger := RNGBlock.trigger + 1 "updating the RNG's trigger with the new transition number informs the RNG that a new random number has to be computed";
					//Checking if new request is present
					if X.request_trigger > S.previous_request then
						S.pending_request := true;
						S.previous_request := X.request_trigger "at the next transition the previous requests will be equal to the actual ones";
					end if;
					if S.pending_request and S.next_TS_array[1] <= time then
						S.element_to_be_sent := S.element_types[1];
						S.immediate_transition_required := true;
					end if;
					if S.immediate_transition_required then
						S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
					elseif S.pending_request then
						S.next_TS := S.next_TS_array[1];
						S.element_to_be_sent := S.element_types[1];
					else
						S.next_TS := Modelica.Constants.inf;
					end if;			
				elsewhen pre(external_transition) then
				//EXTERNAL TRANSITION CODE
				
					STATS.averageWIPs1InPlant := (STATS.averageWIPs1InPlant * (time - elapsed_time) + STATS.WIP1InPlant * elapsed_time) / time;
					STATS.averageWIPs2InPlant := (STATS.averageWIPs2InPlant * (time - elapsed_time) + STATS.WIP2InPlant * elapsed_time) / time;
					
					S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
					for i in 1:n_inputs loop
						if X.event_trigger[i] - S.previous_inputs[i] > 0 then
							if S.elements_waiting < capacity then
								S.elements_waiting := S.elements_waiting + 1;
								S.next_TS_array[S.elements_waiting] := time + RNGBlock.randomValue;
								S.element_types[S.elements_waiting] := X.event_trigger[i] - S.previous_inputs[i];
								if X.event_trigger[i] - S.previous_inputs[i] == 2 then
									STATS.WIP1InPlant := STATS.WIP1InPlant + 1;
									STATS.WIP2InPlant := STATS.WIP2InPlant - 1;
								end if;
								S.previous_inputs[i] := X.event_trigger[i] "at the next transition the previous inputs will be equal to the actual ones";
							else //if an event is acquired and the capacity is exceeded then a relief event is sent immediately
								S.immediate_transition_required := true;
								S.relief_elements_sent := S.relief_elements_sent + relief_specific_value;
								
								if X.event_trigger[i] - S.previous_inputs[i] == 1 then
									STATS.WIP1InPlant := STATS.WIP1InPlant - 1;
									STATS.WIP2InPlant := STATS.WIP2InPlant + 1;
								end if;
								
								S.previous_inputs[i] := X.event_trigger[i] "at the next transition the previous inputs will be equal to the actual ones";
								S.element_to_be_sent := 0;
							end if;		
						end if;
					end for "Cicle aimed at acquiring new elements";
					RNGBlock.trigger := RNGBlock.trigger + 1 "updating the RNG's trigger with the new transition number informs the RNG that a new random number has to be computed";
					//Checking if new request is present
					if X.request_trigger > S.previous_request then
						S.pending_request := true;
						S.previous_request := X.request_trigger "at the next transition the previous requests will be equal to the actual ones";
					end if;
					
					if S.pending_request and S.next_TS_array[1] <= time then
						S.element_to_be_sent := S.element_types[1];
						S.immediate_transition_required := true;
						
					end if;
					if S.immediate_transition_required then
						S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
					elseif S.pending_request then
						S.next_TS := S.next_TS_array[1];
						S.element_to_be_sent := S.element_types[1];
					else
						S.next_TS := Modelica.Constants.inf;
					end if;			
				elsewhen pre(internal_transition) then
				//INTERNAL TRANSITION CODE
				
					STATS.averageWIPs1InPlant := (STATS.averageWIPs1InPlant * (time - elapsed_time) + STATS.WIP1InPlant * elapsed_time) / time;
					STATS.averageWIPs2InPlant := (STATS.averageWIPs2InPlant * (time - elapsed_time) + STATS.WIP2InPlant * elapsed_time) / time;
				
					if S.element_to_be_sent > 0 then
					
						STATS.averageWaitingTime := (STATS.averageWaitingTime * (STATS.WIP1Sent + STATS.WIP2Sent) + (time - S.next_TS_array[1])) / (STATS.WIP1Sent + STATS.WIP2Sent + 1);
					
						if S.element_to_be_sent == 1 then
							STATS.WIP1Sent := STATS.WIP1Sent + 1;
						elseif S.element_to_be_sent == 2 then
							STATS.WIP2Sent := STATS.WIP2Sent + 1;
						end if;
					end if;
					
					S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
					if S.element_to_be_sent > 0 then
						S.pending_request := false;
						S.elements_sent := S.elements_sent + S.element_to_be_sent "after every internal transition update the amount of elements already sent";
						S.element_to_be_sent := 0;
						S.elements_waiting := S.elements_waiting - 1;
						for i in 1:S.elements_waiting loop
							S.next_TS_array[i] := S.next_TS_array[i + 1];
							S.element_types[i] := S.element_types[i + 1];
						end for;
						if S.elements_waiting + 1 <= size(S.next_TS_array, 1) and S.elements_waiting + 1 <= size(S.element_types, 1) then
							S.next_TS_array[S.elements_waiting + 1] := Modelica.Constants.inf;
							S.element_types[S.elements_waiting + 1] := 0;		
						end if;		
					end if "if at the last transition an element has been sent, remove it from the queue";
					if S.immediate_transition_required then
						S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
					elseif S.pending_request then
						S.next_TS := S.next_TS_array[1];
						S.element_to_be_sent := S.element_types[1];
					else
						S.next_TS := Modelica.Constants.inf;
					end if;
				end when;
			///////////////////////////////////////////////////////////////////////
			//                     END OF TRANSITIONS CODE                       //
			///////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////
			//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
			///////////////////////////////////////////////////////////////////////
			//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables	
			algorithm
				when pre(external_event) then
					for i in 1:n_inputs loop					
						X.event_trigger[i] := pre(IN[i].event_signal);
					end for;
					for i in 1:n_outputs loop
						X.request_trigger := pre(OUT[i].event_request_signal);
					end for;
				end when;
			///////////////////////////////////////////////////////////////////////
			//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
			///////////////////////////////////////////////////////////////////////
			equation
				for i in 1:n_inputs loop
					external_event[i] = change(IN[i].event_signal);
					IN[i].event_request_signal = Y.input_ports_value;
				end for;
				for i in 1:n_outputs loop
					OUT[i].event_signal = Y.elements_sent;
					external_event[n_inputs + i] = change(OUT[i].event_request_signal);
					RELIEF[i].event_signal = Y.relief_elements_sent;
				end for;
			end TwoWayQueue;
		  
		end TwoWayQueue_PKG;
		
		
		
		package ReceivalDelayer_PKG
			
			record StateRdl
				extends Atomic_PKG.State;
				Integer elements_sent;
				discrete Real next_TS;
				Integer request_trigger;
			end StateRdl;
			
			record InputVariables_XRdl
				extends Atomic_PKG.InputVariables_X;
				Integer event_trigger;
				Integer request_trigger;
			end InputVariables_XRdl;
			
			record OutputVariables_YRdl
				extends Atomic_PKG.OutputVariables_Y;
				Integer elements_sent;
				Integer request_trigger;
			end OutputVariables_YRdl;
		  
			block ReceivalDelayer "block to be placed between a queue and a server, should transmit requests from the server to the queue, and delay the events sent out of the queue"
				extends Atomic_PKG.Atomic(redeclare StateRdl S, redeclare OutputVariables_YRdl Y, redeclare InputVariables_XRdl X, n_inputs = nInputs, redeclare Boolean external_event[n_inputs + n_outputs], n_outputs = nOutputs);
				constant Integer nInputs = 1 "number of input ports of the system";
				constant Integer nOutputs = 1 "number of output ports of the system";
				//Random number generation components
				RNG.RandomGenerator RNGBlock(localSeed = localSeed, globalSeed = globalSeed, distributionSelected = distributionSelected, distributionParameter1 = distributionParameter1, distributionParameter2 = distributionParameter2);
				parameter Integer localSeed = 10 "localSeed of the RNG";
				parameter Integer globalSeed = 7 "globalSeed of the RNG";
				parameter Integer distributionSelected = 0 "0 = constant; 1 = uniform; 2 = exponential";
				parameter Real distributionParameter1 = 1;
				parameter Real distributionParameter2 = 0 "used only in uniform distrib";
				//Block's ports
				Interfaces.In_Port IN[n_inputs] annotation(
	          Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
				Interfaces.Out_Port OUT[n_outputs] annotation(
	          Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
			initial algorithm
				S.next_TS := Modelica.Constants.inf;
				next_TS := S.next_TS;
				
			algorithm
			//UPDATING next_TS
				when pre(transition_happened) then
					next_TS := S.next_TS "After every transition next_TS equals the value set into the state";
				end when;
			algorithm
				when pre(internal_transition_planned[1]) then				
					Y.elements_sent := S.elements_sent;
					Y.request_trigger := S.request_trigger;
				end when;
			///////////////////////////////////////////////////////////////////////
			//                        TRANSITIONS CODE                           //
			///////////////////////////////////////////////////////////////////////
			algorithm
				when pre(confluent_transition) then
				//CONFLUENT TRANSITION CODE
					
					if X.request_trigger > S.request_trigger then
						S.request_trigger := X.request_trigger;
						S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
					elseif X.event_trigger > S.elements_sent then
						S.elements_sent := X.event_trigger;
						S.next_TS := time + RNGBlock.randomValue;
						RNGBlock.trigger := RNGBlock.trigger + 1 "updating the RNG's trigger with the new transition number informs the RNG that a new random number has to be computed";
					else
						S.next_TS := Modelica.Constants.inf;
					end if;				
				elsewhen pre(external_transition) then
				//EXTERNAL TRANSITION CODE
					
					if X.request_trigger > S.request_trigger then
						S.request_trigger := X.request_trigger;
						S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
					elseif X.event_trigger > S.elements_sent then
						S.elements_sent := X.event_trigger;
						S.next_TS := time + RNGBlock.randomValue;
						RNGBlock.trigger := RNGBlock.trigger + 1 "updating the RNG's trigger with the new transition number informs the RNG that a new random number has to be computed";
					else
						S.next_TS := Modelica.Constants.inf;
					end if;					
				elsewhen pre(internal_transition) then
				//INTERNAL TRANSITION CODE
					
					S.next_TS := Modelica.Constants.inf;
				end when;
			///////////////////////////////////////////////////////////////////////
			//                     END OF TRANSITIONS CODE                       //
			///////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////
			//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
			///////////////////////////////////////////////////////////////////////
			//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables	
			algorithm
				when pre(external_event) then
					for i in 1:n_inputs loop					
						X.event_trigger := pre(IN[i].event_signal);
					end for;
					for i in 1:n_outputs loop
						X.request_trigger := pre(OUT[i].event_request_signal);
					end for;
				end when;
			///////////////////////////////////////////////////////////////////////
			//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
			///////////////////////////////////////////////////////////////////////
			equation
				for i in 1:n_inputs loop
					external_event[i] = change(IN[i].event_signal);
					IN[i].event_request_signal = Y.request_trigger;
				end for;
				for i in 1:n_outputs loop
					OUT[i].event_signal = Y.elements_sent;
					external_event[n_inputs + i] = change(OUT[i].event_request_signal);
				end for;
			end ReceivalDelayer;
			
		end ReceivalDelayer_PKG;
		
		
		
		package Delay_PKG
		
			record StateDel
				extends Atomic_PKG.State;
				parameter Integer n_inputs;
				parameter Integer capacity "amount of elements that can be delayed at the same time";
				discrete Real next_TS;
				discrete Real next_TS_array[capacity + 2*n_inputs] "array containing availability times for elements arrived at the queue";
				Integer element_types[capacity + 2*n_inputs] "array containing the types of elementes in the queue";
				Integer previous_inputs[n_inputs] "Input events at the end of the last transition";		
				Boolean blocked_output "true when OUT.event_request_signal differs from zero, thus output is blocked";						Integer elements_waiting "elements insde the delay block";
				Integer elements_sent "elements sent out of the block";
				Integer elements_discarded "elements that the block is not able to hold and that it discards out of the system";
				Integer element_to_be_sent "amount of elements that are sent at transition";
				Boolean immediate_transition_required "used to indicate that an internal transition has to be fired immediately to change settings in the input";
				Boolean blocking_input "true if input has to be blocked";
				Boolean element_sent_at_last_transition "true when an element has been sent at the last transition, so to trigger an internal transition with no sending, to give time to blocks at output to eventually block ports";
			end StateDel;
			
			record InputVariables_XDel
				extends Atomic_PKG.InputVariables_X;
				parameter Integer n_inputs;
				parameter Integer n_outputs;
				Integer event_trigger[n_inputs] "number of elements arrived in input";
				Boolean port_blocked[n_outputs] "Array that stores information about blockage of output ports (an output port is considered blocked when its request value is different from 0)";
			end InputVariables_XDel;
			
			record OutputVariables_YDel
				extends Atomic_PKG.OutputVariables_Y;
				parameter Integer n_outputs;
				Integer elements_sent[n_outputs] "elements sent as output to requesting blocks";
				Integer input_ports_value "Value used to eventually block input ports";
			end OutputVariables_YDel;
		  
			block Delay
				extends Atomic_PKG.Atomic(redeclare StateDel S(capacity = capacity, n_inputs = n_inputs), redeclare OutputVariables_YDel Y(n_outputs = n_outputs), redeclare InputVariables_XDel X(n_inputs = n_inputs, n_outputs = n_outputs), n_inputs = nInputs, redeclare Boolean external_event[n_inputs + n_outputs], n_outputs = nOutputs);
				constant Integer nInputs = 1 "number of input ports of the system";
				constant Integer nOutputs = 1 "number of output ports of the system";			
				parameter Integer capacity = 100 "amount of elements that can be delayed at the same time";
				parameter Boolean allow_elements_in_excess = true "If true, when elements surpassing the capacity arrive, they are retained if less than the twice the number of inputs. If false, elements in excess are discarded";
				//Random number generation components
				RNG.RandomGenerator RNGBlock(localSeed = localSeed, globalSeed = globalSeed, distributionSelected = distributionSelected, distributionParameter1 = distributionParameter1, distributionParameter2 = distributionParameter2);
				parameter Integer localSeed = 10 "localSeed of the RNG";
				parameter Integer globalSeed = 7 "globalSeed of the RNG";
				parameter Integer distributionSelected = 0 "0 = constant; 1 = uniform; 2 = exponential";
				parameter Real distributionParameter1 = 1;
				parameter Real distributionParameter2 = 0 "used only in uniform distrib";
				//Block's ports
				Interfaces.In_Port IN[n_inputs] annotation(
	          Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
				Interfaces.Out_Port OUT[n_outputs] annotation(
	          Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
			initial algorithm
				S.elements_waiting := 0;
				S.elements_sent := 0;
				S.element_to_be_sent := 0;		
				S.elements_discarded := 0;
				S.element_sent_at_last_transition := false;	
				for i in 1:size(S.next_TS_array, 1) loop
					S.next_TS_array[i] := Modelica.Constants.inf;
					S.element_types[i] := 0;
				end for;
				S.next_TS := Modelica.Constants.inf;
				next_TS := S.next_TS;
				S.blocked_output := false;
				S.blocking_input := S.elements_waiting >= capacity;
				S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
				for i in 1:n_inputs loop
					S.previous_inputs[i] := 0;
				end for;
			algorithm
			//UPDATING next_TS
				when pre(transition_happened) then
					next_TS := S.next_TS "After every transition next_TS equals the value set into the state";
				end when;
			algorithm
				when pre(internal_transition_planned[1]) then
					for i in 1:n_outputs loop
						Y.elements_sent[i] := S.elements_sent + S.element_to_be_sent;
					end for;
					if S.blocking_input then
						Y.input_ports_value := -1;
					else
						Y.input_ports_value := 0;
					end if "If output ports are set ot  be blocked then request value is set to -1, otherwise 0";
				end when;
			///////////////////////////////////////////////////////////////////////
			//                        TRANSITIONS CODE                           //
			///////////////////////////////////////////////////////////////////////
			algorithm
				when pre(confluent_transition) then
				//CONFLUENT TRANSITION CODE
					
					//Updating the elements in the block after a sending
					if S.element_to_be_sent > 0 then //If at the last transition an element has been sent
						S.elements_sent := S.elements_sent + S.element_to_be_sent "after every internal transition update the amount of elements already sent is augmented to keep track of the last sending";
						S.elements_waiting := S.elements_waiting - 1 "an element is removed from the queue";
						S.element_to_be_sent := 0;
						for i in 1:S.elements_waiting loop
							if i + 1 <= size(S.next_TS_array, 1) and i + 1 <= size(S.element_types, 1) then
								S.next_TS_array[i] := S.next_TS_array[i + 1];
								S.element_types[i] := S.element_types[i + 1];
							end if;
						end for "for loop used to move by one position the elements of queue's arrays";
						S.next_TS_array[S.elements_waiting + 1] := Modelica.Constants.inf;
						S.element_types[S.elements_waiting + 1] := 0 "in place of the last element the end of the queue a non existing element is placed";
						S.element_sent_at_last_transition := true;
					else
						S.element_sent_at_last_transition := false;
					end if "if at the last transition an element has been sent, remove it from the queue";
					for i in 1:n_inputs loop
						if X.event_trigger[i] - S.previous_inputs[i] > 0 then						
							if allow_elements_in_excess and S.elements_waiting < size(S.next_TS_array, 1) and S.elements_waiting < size(S.element_types, 1) then
								S.elements_waiting := S.elements_waiting + 1;
								S.next_TS_array[S.elements_waiting] := time + RNGBlock.randomValue;
								S.element_types[S.elements_waiting] := X.event_trigger[i] - S.previous_inputs[i];
								S.previous_inputs[i] := X.event_trigger[i] "at the next transition the previous inputs will be equal to the actual ones";	
							elseif not allow_elements_in_excess and S.elements_waiting < capacity then
								S.elements_waiting := S.elements_waiting + 1;
								S.next_TS_array[S.elements_waiting] := time + RNGBlock.randomValue;
								S.element_types[S.elements_waiting] := X.event_trigger[i] - S.previous_inputs[i];
								S.previous_inputs[i] := X.event_trigger[i] "at the next transition the previous inputs will be equal to the actual ones";	
							else
								S.previous_inputs[i] := X.event_trigger[i] "at the next transition the previous inputs will be equal to the actual ones";	
								S.elements_discarded := S.elements_discarded + 1;
							end if;	
						end if;
					end for "Cicle aimed at acquiring new elements";
					RNGBlock.trigger := RNGBlock.trigger + 1 "augmenting the RNG trigger to require the generation of a new random number";
					S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
					if S.elements_waiting >= capacity and not S.blocking_input then //In case the queue contains more elements than allowed and the input ports are not blocked, then block them immediately by setting immediate_transition_required to true
						S.blocking_input := true;
						S.immediate_transition_required := true;
						S.element_to_be_sent := 0 "in case an internal transition has to fired immediately, don't send anything";
					elseif S.elements_waiting < capacity and S.blocking_input then //In case the port was locked but there is room for elements, unlock the inputs immediately by setting immediate_transition_required to true
						S.blocking_input := false;
						S.immediate_transition_required := true;
						S.element_to_be_sent := 0 "in case an internal transition has to fired immediately, don't send anything";
					end if "if branch used to handle the blocking of input ports";
					S.blocked_output := false "At the beginning of every transition it is assumed that the output is not blocked, to then check for every port"; 
					for i in 1:n_outputs loop
						if X.port_blocked[i] then
							S.blocked_output := true "If any port is found blocked the whole system considers the output blocked"; 
						end if;
					end for "loop aimed at checking if any of the output ports is considered blocked";
					if S.immediate_transition_required or (S.element_sent_at_last_transition and S.next_TS_array[1] <= time) then
						S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "in case an immediate response is required, an apposite function manipulates next_TS to trigger it directly inside the event iteration without waiting for simulation time";
					elseif not S.blocked_output then //if the output is not blocked
						S.next_TS := S.next_TS_array[1] ;
						S.element_to_be_sent := S.element_types[1];
						if S.elements_waiting <= capacity then
							S.blocking_input := false;
						end if "if the capacity is equal to the elements inside the queue, at the next transition, after the sending, the input ports wll be unlocked";
					else
						S.next_TS := Modelica.Constants.inf "without requests or responses to be ginven the queue stays idle";
					end if;
					
				elsewhen pre(external_transition) then
				//EXTERNAL TRANSITION CODE
					
					for i in 1:n_inputs loop
						if X.event_trigger[i] - S.previous_inputs[i] > 0 then						
							if allow_elements_in_excess and S.elements_waiting < size(S.next_TS_array, 1) and S.elements_waiting < size(S.element_types, 1) then
								S.elements_waiting := S.elements_waiting + 1;
								S.next_TS_array[S.elements_waiting] := time + RNGBlock.randomValue;
								S.element_types[S.elements_waiting] := X.event_trigger[i] - S.previous_inputs[i];
								S.previous_inputs[i] := X.event_trigger[i] "at the next transition the previous inputs will be equal to the actual ones";	
							elseif not allow_elements_in_excess and S.elements_waiting < capacity then
								S.elements_waiting := S.elements_waiting + 1;
								S.next_TS_array[S.elements_waiting] := time + RNGBlock.randomValue;
								S.element_types[S.elements_waiting] := X.event_trigger[i] - S.previous_inputs[i];
								S.previous_inputs[i] := X.event_trigger[i] "at the next transition the previous inputs will be equal to the actual ones";	
							else
								S.previous_inputs[i] := X.event_trigger[i] "at the next transition the previous inputs will be equal to the actual ones";	
								S.elements_discarded := S.elements_discarded + 1;
							end if;	
						end if;
					end for "Cicle aimed at acquiring new elements";
					RNGBlock.trigger := RNGBlock.trigger + 1 "augmenting the RNG trigger to require the generation of a new random number";
					S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
					if S.elements_waiting >= capacity and not S.blocking_input then //In case the queue contains more elements than allowed and the input ports are not blocked, then block them immediately by setting immediate_transition_required to true
						S.blocking_input := true;
						S.immediate_transition_required := true;
						S.element_to_be_sent := 0 "in case an internal transition has to fired immediately, don't send anything";
					elseif S.elements_waiting < capacity and S.blocking_input then //In case the port was locked but there is room for elements, unlock the inputs immediately by setting immediate_transition_required to true
						S.blocking_input := false;
						S.immediate_transition_required := true;
						S.element_to_be_sent := 0 "in case an internal transition has to fired immediately, don't send anything";
					end if "if branch used to handle the blocking of input ports";
					S.blocked_output := false "At the beginning of every transition it is assumed that the output is not blocked, to then check for every port"; 
					for i in 1:n_outputs loop
						if X.port_blocked[i] then
							S.blocked_output := true "If any port is found blocked the whole system considers the output blocked"; 
						end if;
					end for "loop aimed at checking if any of the output ports is considered blocked";
					if S.immediate_transition_required or (S.element_sent_at_last_transition and S.next_TS_array[1] <= time) then
						S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "in case an immediate response is required, an apposite function manipulates next_TS to trigger it directly inside the event iteration without waiting for simulation time";
					elseif not S.blocked_output then //if the output is not blocked
						S.next_TS := S.next_TS_array[1] ;
						S.element_to_be_sent := S.element_types[1];
						if S.elements_waiting <= capacity then
							S.blocking_input := false;
						end if "if the capacity is equal to the elements inside the queue, at the next transition, after the sending, the input ports wll be unlocked";
					else
						S.next_TS := Modelica.Constants.inf "without requests or responses to be ginven the queue stays idle";
					end if;
					
				elsewhen pre(internal_transition) then
				//INTERNAL TRANSITION CODE
					
					//Updating the elements in the block after a sending
					if S.element_to_be_sent > 0 then //If at the last transition an element has been sent
						S.elements_sent := S.elements_sent + S.element_to_be_sent "after every internal transition update the amount of elements already sent is augmented to keep track of the last sending";
						S.elements_waiting := S.elements_waiting - 1 "an element is removed from the queue";
						S.element_to_be_sent := 0;
						for i in 1:S.elements_waiting loop
							if i + 1 <= size(S.next_TS_array, 1) and i + 1 <= size(S.element_types, 1) then
								S.next_TS_array[i] := S.next_TS_array[i + 1];
								S.element_types[i] := S.element_types[i + 1];
							end if;
						end for "for loop used to move by one position the elements of queue's arrays";
						S.next_TS_array[S.elements_waiting + 1] := Modelica.Constants.inf;
						S.element_types[S.elements_waiting + 1] := 0 "in place of the last element the end of the queue a non existing element is placed";
						S.element_sent_at_last_transition := true;
					else
						S.element_sent_at_last_transition := false;		
					end if "if at the last transition an element has been sent, remove it from the queue";
					S.immediate_transition_required := false "at the beginning of every transition we assume no immediate transition will be needed, to then check if it is over the course of the function";
					if S.elements_waiting >= capacity and not S.blocking_input then //In case the queue contains more elements than allowed and the input ports are not blocked, then block them immediately by setting immediate_transition_required to true
						S.blocking_input := true;
						S.immediate_transition_required := true;
						S.element_to_be_sent := 0 "in case an internal transition has to fired immediately, don't send anything";
					elseif S.elements_waiting < capacity and S.blocking_input then //In case the port was locked but there is room for elements, unlock the inputs immediately by setting immediate_transition_required to true
						S.blocking_input := false;
						S.immediate_transition_required := true;
						S.element_to_be_sent := 0 "in case an internal transition has to fired immediately, don't send anything";
					end if "if branch used to handle the blocking of input ports";
					if S.immediate_transition_required or (S.element_sent_at_last_transition and S.next_TS_array[1] <= time) then
						S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "in case an immediate response is required, an apposite function manipulates next_TS to trigger it directly inside the event iteration without waiting for simulation time";
					elseif not S.blocked_output then //if the output is not blocked
						S.next_TS := S.next_TS_array[1] ;
						S.element_to_be_sent := S.element_types[1];
						if S.elements_waiting <= capacity then
							S.blocking_input := false;
						end if "if the capacity is equal to the elements inside the queue, at the next transition, after the sending, the input ports wll be unlocked";
					else
						S.next_TS := Modelica.Constants.inf "without requests or responses to be ginven the queue stays idle";
					end if;
					
				end when;
			///////////////////////////////////////////////////////////////////////
			//                     END OF TRANSITIONS CODE                       //
			///////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////
			//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
			///////////////////////////////////////////////////////////////////////
			//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables	
			algorithm
				when pre(external_event) then
					for i in 1:n_inputs loop					
						X.event_trigger[i] := pre(IN[i].event_signal);
					end for;
					for i in 1:n_outputs loop
						X.port_blocked[i] := not pre(OUT[i].event_request_signal) == 0 "If the output port request's values is different from 0 the port is considered blocked";
					end for;
				end when;
			///////////////////////////////////////////////////////////////////////
			//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
			///////////////////////////////////////////////////////////////////////
			equation
				for i in 1:n_inputs loop
					external_event[i] = change(IN[i].event_signal);
					IN[i].event_request_signal = Y.input_ports_value;
				end for;
				for i in 1:n_outputs loop
					OUT[i].event_signal = Y.elements_sent[i];
					external_event[n_inputs + i] = change(OUT[i].event_request_signal);
				end for;
			end Delay;
		  
		end Delay_PKG;
		
		
		
		package Displacer_PKG
		
			record StateDis
				extends Atomic_PKG.State;
				Integer elements_sent;
				discrete Real next_TS;
				Integer elements_finished;
				Integer previous_input;
				Integer request_trigger;
				Boolean immediate_transition_required;
			end StateDis;
			
			record InputVariables_XDis
				extends Atomic_PKG.InputVariables_X;
				Integer event_trigger;
				Integer request_trigger;
			end InputVariables_XDis;
			
			record OutputVariables_YDis
				extends Atomic_PKG.OutputVariables_Y;
				Integer elements_sent;
				Integer request_trigger;
			end OutputVariables_YDis;
		  
			block Displacer "block that displaces out of the system elements finished and sends again as outputs elements unfinished"
				extends Atomic_PKG.Atomic(redeclare StateDis S, redeclare OutputVariables_YDis Y, redeclare InputVariables_XDis X, n_inputs = nInputs, redeclare Boolean external_event[n_inputs + n_outputs], n_outputs = nOutputs);
				constant Integer nInputs = 1 "number of input ports of the system";
				constant Integer nOutputs = 1 "number of output ports of the system";
				Interfaces.In_Port IN[n_inputs] annotation(
	          Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
				Interfaces.Out_Port OUT[n_outputs] annotation(
	          Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
			initial algorithm
				S.next_TS := Modelica.Constants.inf;
				next_TS := S.next_TS;
				
			algorithm
			//UPDATING next_TS
				when pre(transition_happened) then
					next_TS := S.next_TS "After every transition next_TS equals the value set into the state";
				end when;
			algorithm
				when pre(internal_transition_planned[1]) then				
					Y.elements_sent := S.elements_sent;
					Y.request_trigger := S.request_trigger;
				end when;
			///////////////////////////////////////////////////////////////////////
			//                        TRANSITIONS CODE                           //
			///////////////////////////////////////////////////////////////////////
			algorithm
				when pre(confluent_transition) then
				//CONFLUENT TRANSITION CODE
				
					S.immediate_transition_required := false;
					
					if not X.request_trigger == S.request_trigger then
						S.request_trigger := X.request_trigger;
						S.immediate_transition_required := true;
					end if;
					
					if X.event_trigger - S.previous_input == 1 then
						S.previous_input := X.event_trigger;
						S.immediate_transition_required := true;
						//S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
						S.elements_finished := S.elements_finished + 1;
						S.elements_sent := S.elements_sent + 1;
					elseif X.event_trigger - S.previous_input == 2 then
						S.previous_input := X.event_trigger;
						S.elements_sent := S.elements_sent + 2;
						S.immediate_transition_required := true;
						//S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
					end if;
					
					if S.immediate_transition_required then
						S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
					else
						S.next_TS := Modelica.Constants.inf;
						S.previous_input := X.event_trigger;
					end if;				
				elsewhen pre(external_transition) then
				//EXTERNAL TRANSITION CODE
					
					S.immediate_transition_required := false;
					
					if not X.request_trigger == S.request_trigger then
						S.request_trigger := X.request_trigger;
						S.immediate_transition_required := true;
					end if;
					
					if X.event_trigger - S.previous_input == 1 then
						S.previous_input := X.event_trigger;
						S.immediate_transition_required := true;
						//S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
						S.elements_finished := S.elements_finished + 1;
						S.elements_sent := S.elements_sent + 1;
					elseif X.event_trigger - S.previous_input == 2 then
						S.previous_input := X.event_trigger;
						S.elements_sent := S.elements_sent + 2;
						S.immediate_transition_required := true;
						//S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
					end if;
					
					if S.immediate_transition_required then
						S.next_TS := Functions.ImmediateInternalTransition(S.next_TS) "if an immediate transition is required, this function changes next_TS to a negative number lesser than the actual one";
					else
						S.next_TS := Modelica.Constants.inf;
						S.previous_input := X.event_trigger;
					end if;						
				elsewhen pre(internal_transition) then
				//INTERNAL TRANSITION CODE
					S.immediate_transition_required := false;
					S.next_TS := Modelica.Constants.inf;
				end when;
			///////////////////////////////////////////////////////////////////////
			//                     END OF TRANSITIONS CODE                       //
			///////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////
			//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
			///////////////////////////////////////////////////////////////////////
			//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables	
			algorithm
				when pre(external_event) then
					for i in 1:n_inputs loop					
						X.event_trigger := pre(IN[i].event_signal);
					end for;
					for i in 1:n_outputs loop
						X.request_trigger := pre(OUT[i].event_request_signal);
					end for;
				end when;
			///////////////////////////////////////////////////////////////////////
			//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
			///////////////////////////////////////////////////////////////////////
			equation
				for i in 1:n_inputs loop
					external_event[i] = change(IN[i].event_signal);
					IN[i].event_request_signal = Y.request_trigger;
				end for;
				for i in 1:n_outputs loop
					OUT[i].event_signal = Y.elements_sent;
					external_event[n_inputs + i] = change(OUT[i].event_request_signal);
				end for;
			end Displacer;
		  
		end Displacer_PKG;
	
	
	end I40Lab;
	
	
	
	package ServerExample_PKG "Package for server example provided in thesis at chapter 3.1.3"
	
		record StateSer
			extends Atomic_PKG.State;
			discrete Real next_TS"time of next scheduled internal transition";
			Integer elements_processed "Elements successfully processed by the server";			
			Integer request "Requests sent by the server";			
			Boolean active "true if the server is working on a part or not";
			Integer acquired_inputs "Input events at the end of the last transition";
		end StateSer;
		
		record InputVariables_XSer
			extends Atomic_PKG.InputVariables_X;
			Integer events_arrived "Events arrived at this event_iteration";
		end InputVariables_XSer;
		
		record OutputVariables_YSer
			extends Atomic_PKG.OutputVariables_Y;
			Integer elements_processed "Elements successfully processed by the server";
			Integer request;
		end OutputVariables_YSer;
		
		block Server
			extends Atomic_PKG.Atomic(redeclare StateSer S, redeclare OutputVariables_YSer Y, redeclare InputVariables_XSer X, n_inputs = 1, n_outputs = 1, redeclare Boolean external_event[n_inputs]);
			parameter Real timeadvance = 3.0;
			//Block's ports
			In_Port IN annotation(
          Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
			Out_Port OUT annotation(
          Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
		initial algorithm
			S.next_TS := 0 "the next internal transition is scheduled at time 0 to send a request";
			S.request := 1 "the beginning request to be sent is equal to the amount of entities required to start a process";
			S.active := false "server starts idle";
			S.acquired_inputs := 0;
			S.elements_processed := 0 "server starts with no elements processed";
			Y.elements_processed := 0;
			Y.request := 0;
			X.events_arrived := 0;
			next_TS := S.next_TS;
		algorithm
		//UPDATING next_TS
			when pre(transition_happened) then
				next_TS := S.next_TS "After every transition next_TS equals the value set into the state";
			end when;
		algorithm
			when pre(internal_transition_planned[1]) then //MAYBE A pre() HERE SHOULD PUT TOO
				Y.elements_processed := S.elements_processed;
				Y.request := S.request;
			end when;
			/*when internal_transition_planned[2] then
				OUT.event_signal := Y.elements_processed;
				IN.event_request_signal := Y.request;
			end when;*/
		///////////////////////////////////////////////////////////////////////
		//                        TRANSITIONS CODE                           //
		///////////////////////////////////////////////////////////////////////
		algorithm
			when pre(confluent_transition) then
			//CONFLUENT TRANSITION CODE
				if  X.events_arrived > S.acquired_inputs then
					S.elements_processed := S.elements_processed + 1;
					S.request := S.request + 1;
					S.active := true;
					S.acquired_inputs := S.acquired_inputs + 1;
					S.next_TS := time + timeadvance;
				else
					S.next_TS := Modelica.Constants.inf;
					S.active := false;
				end if;
			elsewhen pre(external_transition) then
			//EXTERNAL TRANSITION CODE
				if not S.active and X.events_arrived > S.acquired_inputs then
					S.elements_processed := S.elements_processed + 1;
					S.request := S.request + 1;
					S.active := true;
					S.acquired_inputs := S.acquired_inputs + 1;
					S.next_TS := time + timeadvance;
				end if;
			elsewhen pre(internal_transition) then
			//INTERNAL TRANSITION CODE
				S.next_TS := Modelica.Constants.inf;
				S.active := false;
			end when;	
		///////////////////////////////////////////////////////////////////////
		//                     END OF TRANSITIONS CODE                       //
		///////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
		///////////////////////////////////////////////////////////////////////
		//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables
		algorithm
			when pre(external_event) then
				X.events_arrived := pre(IN.event_signal);
			end when;
		///////////////////////////////////////////////////////////////////////
		//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
		///////////////////////////////////////////////////////////////////////
		equation
			OUT.event_signal = Y.elements_processed;
			IN.event_request_signal = Y.request;
			external_event[1] = change(IN.event_signal);
		end Server;
	  
	end ServerExample_PKG;
	
	
	
	package EventsLib2 "Very very ambitious package, I already know it will never be brought to life"
	
		constant Integer TRANSMISSION_BUFFER_SIZE = 2;
	
		
		
		package Entities "Package containg entities data. Probably it will contain just one record and thus it will be highly redundant over time, but right now I have no power in foreseeing the destiny of EventsLib2. SERIOUS AND TEMPORARY NOTE: in this embrional stage I would like only to concentrate on some entities transmissions between basic blocks"
			
			record BaseEntity "Starting experimental entity from which all other entities will inherit"
				discrete Real ID_number;
			end BaseEntity;
			
		end Entities;
		
		package Functions
	
			function ImmediateInternalTransition "function used to decrement next internal transition time to trigger consecutive internal transitions"
				input Real next_TS_in;
				output Real next_TS_out;
			algorithm
				if next_TS_in >= 0 then
					next_TS_out := -1;
				else
					next_TS_out := next_TS_in - 1;
				end if;
			end ImmediateInternalTransition;

		end Functions;
		
		package Interfaces "Package containing interfaces for DEVS models"
		
			connector InPort
				input Integer external_event_input_signal "Trigger supposed to communicate whether or not a set of external events are coming";
				input Integer transmission_batch_size "Amount of entities currently being transmitted in the last batch";
				input Entities.BaseEntity entities_transmission_buffer[TRANSMISSION_BUFFER_SIZE] "Buffer containing entities being sent";
				output Integer batch_entities_acquired "Auxiliary transmission variable used by the receiver to inform the server of complete messages acquiral";
				//output Integer external_event_output_signal "TEMPORARY NOTE: THIS IS A VERY VERY UNUSEFUL VARIABLE AT THE MOMENT AND SO IT WILL COMMENTED OUT OF THE CLASS. WHENEVER THE NEED OF HAVING DIFFERENT POSSIBLE MESSAGES FROM RECEIVER TO SENDER, IT MAY RESULT USEFUL AND SO IT WOULD BE USED AS AN EVENT TRIGGER";
			end InPort;
			
			connector OutPort
				output Integer external_event_input_signal "Trigger supposed to communicate whether or not a set of external events are coming";
				output Integer transmission_batch_size "Amount of entities currently being transmitted in the last batch";
				output Entities.BaseEntity entities_transmission_buffer[TRANSMISSION_BUFFER_SIZE] "Buffer containing entities being sent";
				input Integer batch_entities_acquired "Auxiliary transmission variable used by the receiver to inform the server of complete messages acquiral";
				//input Integer external_event_output_signal "TEMPORARY NOTE: THIS IS A VERY VERY UNUSEFUL VARIABLE AT THE MOMENT AND SO IT WILL COMMENTED OUT OF THE CLASS. WHENEVER THE NEED OF HAVING DIFFERENT POSSIBLE MESSAGES FROM RECEIVER TO SENDER, IT MAY RESULT USEFUL AND SO IT WOULD BE USED AS AN EVENT TRIGGER";
			end OutPort;
		  
		end Interfaces;	
	
		package BlocksPackages
		
			package Generator
			
				record StateGen
					extends Atomic_PKG.State;
					Boolean generating "true if generating some entities, false if waiting for entities to be acquired by next block";
					discrete Real next_TS "Time instant of next scheduled internal transition";
					Entities.BaseEntity entities_being_generated[TRANSMISSION_BUFFER_SIZE] "Record array containing data of entities";
					Integer n_entities_generated "number of entities being successfully generated";
					//VARIABLES ADDED IN A TENTATIVE TO SOLVE PANTELIDES PROBLEM, SINCE LAMBDA OUTPUT FUNCTION RISKS TO BE "UNDERINFLUENCED" BY THE STATE
					Integer entities_in_batch;
					Integer trigger;
				end StateGen;
				
				record InputVariables_XGen
					extends Atomic_PKG.InputVariables_X;
					Integer n_entities_successfully_transmitted;
				end InputVariables_XGen;
				
				record OutputVariables_YGen
					extends Atomic_PKG.OutputVariables_Y;
					Integer output_trigger_signal;
					Integer transmission_batch_size "Amount of entities currently being transmitted in the last batch";
					Entities.BaseEntity entities_being_sent[TRANSMISSION_BUFFER_SIZE] "Record array containing entities being transmitted";
				end OutputVariables_YGen;
				
				block Generator
					extends Atomic_PKG.Atomic(redeclare StateGen S, redeclare OutputVariables_YGen Y, redeclare InputVariables_XGen X, n_inputs = nInputs, redeclare Boolean external_event[n_inputs + n_outputs], n_outputs = nOutputs);
					constant Integer nInputs = 0 "A generator doesn't have explicit input ports";
					constant Integer nOutputs = 1 "TEMPORARY CONSTANT: in time I will decide what to do with the number of ports of a generator. At the moment I'll let it as a constant equal to 1";
					parameter Real timeadvance = 6;
					parameter Integer batch_dimension = 2 "number of entities generated at every generation TEMPORARY NOTE: in this developmental stage it HAS to be < 20, or the actual constant buffer size. In a smarter architecture YOU  will have to recall that it is better for the state array to be the size of this parameter";
					Interfaces.OutPort OUT;
				initial algorithm
				//INITIALIZATION PHASE FOR VARIABLES
					S.generating := true;
					S.next_TS := time + timeadvance;
					for i in 1:size(S.entities_being_generated ,1) loop
						S.entities_being_generated[i].ID_number := i;
					end for;
					S.n_entities_generated := 0;
				algorithm
				//UPDATING next_TS
					when pre(transition_happened) then
						next_TS := S.next_TS;
					end when;
				algorithm
					when pre(internal_transition_planned[1]) then
						Y.output_trigger_signal := S.trigger;
						Y.transmission_batch_size := S.entities_in_batch;
						for i in 1:size(Y.entities_being_sent ,1) loop
							Y.entities_being_sent[i] := S.entities_being_generated[i];
						end for;
					end when;
				///////////////////////////////////////////////////////////////////////
				//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
				///////////////////////////////////////////////////////////////////////
				//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables
				algorithm
					when pre(external_event) then
						for i in 1:n_outputs loop
							X.n_entities_successfully_transmitted := pre(OUT.batch_entities_acquired);
						end for;
					end when;
				///////////////////////////////////////////////////////////////////////
				//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
				///////////////////////////////////////////////////////////////////////
				///////////////////////////////////////////////////////////////////////
				//                        TRANSITIONS CODE                           //
				///////////////////////////////////////////////////////////////////////
				algorithm		
					when pre(confluent_transition) then
					//CONFLUENT TRANSITION CODE
						//S.state_variable := S.state_variable + 1 "Updating the number of transitions";
						S.generating := true "debugging line, at this stage no need to write down a confluent transition routine";
						for i in 1:size(S.entities_being_generated ,1) loop
							S.entities_being_generated[i].ID_number := i;
						end for;
					elsewhen pre(external_transition) then
					//EXTERNAL TRANSITION CODE
						if X.n_entities_successfully_transmitted == S.n_entities_generated then
							S.generating := X.n_entities_successfully_transmitted == S.n_entities_generated;
							for i in 1:size(S.entities_being_generated ,1) loop
								S.entities_being_generated[i].ID_number := i + S.n_entities_generated;
							end for;
							/*for i in 1:batch_dimension loop
								if i <= TRANSMISSION_BUFFER_SIZE then
									S.entities_being_generated[i].ID_number := i + S.n_entities_generated;
								end if;
							end for "RECALL IN THIS EARLY STAGE OF DEVELOPMENT! YOU ARE NOT MODIFYING THE FULL ARRAY, THUS A SET OF VARIABLES IS CURRENTLY BEING UNSOLVED. THAT MAY CAUSE UNDERDETERMINATION COMPILATION PROBLEMS!";*/
							S.next_TS := time + timeadvance;
						end if "if the number of acquired entities equals the number";
						
					elsewhen pre(internal_transition) then
					//INTERNAL TRANSITION CODE
						S.generating := false;
						S.next_TS := Modelica.Constants.inf;
						S.n_entities_generated := S.n_entities_generated + batch_dimension;
						S.trigger := S.trigger + 1;
						S.entities_in_batch := batch_dimension;
					end when;
				///////////////////////////////////////////////////////////////////////
				//                     END OF TRANSITIONS CODE                       //
				///////////////////////////////////////////////////////////////////////	
				equation
					for i in 1:n_outputs loop
						external_event[i] = change(OUT.batch_entities_acquired);
						OUT.external_event_input_signal = Y.output_trigger_signal;
						OUT.transmission_batch_size = Y.transmission_batch_size;
						for e in 1:TRANSMISSION_BUFFER_SIZE loop
							OUT.entities_transmission_buffer[e] = Y.entities_being_sent[e];
						end for;
					end for;
				end Generator;
			  
			end Generator;
		  
		end BlocksPackages;
		
		package TestingModels "REALLY REALLY IDIOT BLOCKS, NOT FOLLOWING THE DEVS FORMALISM (not so sure now...), JUST TO TEST OTHER BLOCKS, at the moment it contains just the block StupidReceiver"		
			import EventsLib2.TRANSMISSION_BUFFER_SIZE;
			
				record StateStR
					extends Atomic_PKG.State;
					Integer n_entities_received;
					Entities.BaseEntity entities_received[10000] "Storage for received entities, based on a very stupid limited size buffer";
					discrete Real next_TS;
				end StateStR;
				
				record InputVariables_XStR
					extends Atomic_PKG.InputVariables_X;
					Integer transmission_batch_size "Amount of entities currently being transmitted in the last batch";
					Entities.BaseEntity entities_being_transmitted[TRANSMISSION_BUFFER_SIZE] "Record array containing entities being transmitted";
				end InputVariables_XStR;
				
				record OutputVariables_YStR
					extends Atomic_PKG.OutputVariables_Y;
					Integer n_entities_received;
				end OutputVariables_YStR;
		
			block StupidReceiver
				extends Atomic_PKG.Atomic(redeclare StateStR S, redeclare OutputVariables_YStR Y, redeclare InputVariables_XStR X, n_inputs = nInputs, redeclare Boolean external_event[n_inputs + n_outputs], n_outputs = nOutputs);
				constant Integer nInputs = 1;
				constant Integer nOutputs = 0;
				Interfaces.InPort IN[n_inputs];
			initial algorithm
				//INITIALIZATION PHASE FOR VARIABLES
				S.next_TS := Modelica.Constants.inf;
				S.n_entities_received := 0;
			algorithm
			//UPDATING next_TS
				when pre(transition_happened) then
					next_TS := S.next_TS;
				end when;
			algorithm
				when pre(internal_transition_planned[1]) then
					Y.n_entities_received := S.n_entities_received;
				end when;
			///////////////////////////////////////////////////////////////////////
			//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
			///////////////////////////////////////////////////////////////////////
			//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables
			algorithm
				when pre(external_event) then
					for i in 1:n_inputs loop
						X.transmission_batch_size := pre(IN[i].transmission_batch_size);
						for j in 1:X.transmission_batch_size loop
							X.entities_being_transmitted[j].ID_number := pre(IN[i].entities_transmission_buffer[j].ID_number) "OH NO THIS LINE MAY RESULT IN SO MANY PROBLEMS";
						end for;
					end for;
				end when;
			///////////////////////////////////////////////////////////////////////
			//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
			///////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////
			//                        TRANSITIONS CODE                           //
			///////////////////////////////////////////////////////////////////////
			algorithm		
				when pre(confluent_transition) then
				//CONFLUENT TRANSITION CODE
					//S.state_variable := S.state_variable + 1 "Updating the number of transitions";
					
				elsewhen pre(external_transition) then
				//EXTERNAL TRANSITION CODE					
					for i in (1):(X.transmission_batch_size) loop
						S.entities_received[S.n_entities_received + i] := X.entities_being_transmitted[i];
					end for;
					S.n_entities_received := S.n_entities_received + X.transmission_batch_size;
					S.next_TS := -1;//ImmediateInternalTransition(S.next_TS);
				elsewhen pre(internal_transition) then
				//INTERNAL TRANSITION CODE
					S.next_TS := Modelica.Constants.inf;
				end when;
			///////////////////////////////////////////////////////////////////////
			//                     END OF TRANSITIONS CODE                       //
			///////////////////////////////////////////////////////////////////////	
			equation
				for i in 1:1 loop
					external_event[i] = change(IN[i].external_event_input_signal);
					IN[i].batch_entities_acquired = Y.n_entities_received;
				end for;
			end StupidReceiver;
			
			block SeriouslyStupidReceiver
				Interfaces.InPort IN[1];
				//Integer x;
				Integer y;
				Entities.BaseEntity z[TRANSMISSION_BUFFER_SIZE];
			algorithm
				when change(IN[1].external_event_input_signal) then
					y := IN[1].transmission_batch_size;
					z := IN[1].entities_transmission_buffer;
				end when;
			equation
				IN[1].batch_entities_acquired = 0;
			end SeriouslyStupidReceiver;
			
			block SeriouslyStupidSender
				Interfaces.OutPort OUT[1];
				Integer external_event_input_signal "Trigger supposed to communicate whether or not a set of external events are coming";
				Integer transmission_batch_size "Amount of entities currently being transmitted in the last batch";
				Entities.BaseEntity entities_transmission_buffer[TRANSMISSION_BUFFER_SIZE] "Buffer containing entities being sent";
			algorithm
				when time > 0.2 then
					external_event_input_signal := 1;
					transmission_batch_size := 10 "ATTENTION NUC, YOU WILL AHVE TON CHECK WHAT HAPPENS BY DIMINISHING THIS NUMBER!!! MAYBE YOU ARE NOT SOLVING FOR ALL VECTOR VIARIABLES";
					for i in 1:transmission_batch_size loop
					entities_transmission_buffer[i].ID_number := i;
					end for;
				end when;
			equation
				OUT[1].external_event_input_signal = external_event_input_signal;
				OUT[1].transmission_batch_size = transmission_batch_size;
				for e in 1:TRANSMISSION_BUFFER_SIZE loop
					OUT[1].entities_transmission_buffer[e] = entities_transmission_buffer[e];
				end for;
			end SeriouslyStupidSender;
		  
		end TestingModels;
	
	end EventsLib2;
	
	
	
	package PDEVS_STRuctInfo "package aimed at exploring bottom-up the possibilities to"
	
		connector InPort
			input Integer trigger;
			input Integer data;
			output Integer acks;
		end InPort;
		
		connector OutPort
			output Integer trigger;
			output Integer data;
			input Integer acks;
		end OutPort;
		
		package Sender_PKG
		
			record StateSnd
				discrete Real next_TS;
				Integer trigger;
			end StateSnd;
			
			record InputVariables_XSnd
				Integer acks;
			end InputVariables_XSnd;
			
			record OutputVariables_YSnd
				Integer trigger;
				Integer data;
			end OutputVariables_YSnd;
		
			block Sender
				extends Atomic_PKG.Atomic(redeclare StateSnd S, redeclare OutputVariables_YSnd Y, redeclare InputVariables_XSnd X, n_inputs = 1, n_outputs = 1, redeclare Boolean external_event[n_inputs]);
				OutPort OUT;
				parameter Real timeadvance = 3.0;
			initial algorithm
				S.next_TS := timeadvance;
				S.trigger := 1;
				next_TS := S.next_TS;
			algorithm
			//UPDATING next_TS
				when pre(transition_happened) then
					next_TS := S.next_TS "After every transition next_TS equals the value set into the state";
				end when;
			algorithm
				when pre(internal_transition_planned[1]) then //MAYBE A pre() HERE SHOULD PUT TOO
					Y.trigger := S.trigger;
					Y.data := 34;
				end when;
				/*when internal_transition_planned[2] then
					OUT.event_signal := Y.elements_processed;
					IN.event_request_signal := Y.request;
				end when;*/
			///////////////////////////////////////////////////////////////////////
			//                        TRANSITIONS CODE                           //
			///////////////////////////////////////////////////////////////////////
			algorithm
				when pre(confluent_transition) then
				//CONFLUENT TRANSITION CODE
					
				elsewhen pre(external_transition) then
				//EXTERNAL TRANSITION CODE
					if X.acks == S.trigger then
						S.trigger := S.trigger + 1;
						S.next_TS := time + timeadvance;
					end if;
				elsewhen pre(internal_transition) then
				//INTERNAL TRANSITION CODE
					S.next_TS := Modelica.Constants.inf;
				end when;	
			///////////////////////////////////////////////////////////////////////
			//                     END OF TRANSITIONS CODE                       //
			///////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////
			//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
			///////////////////////////////////////////////////////////////////////
			//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables
			algorithm
				when pre(external_event) then
					X.acks := pre(OUT.acks);
				end when;
			///////////////////////////////////////////////////////////////////////
			//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
			///////////////////////////////////////////////////////////////////////
			equation
				OUT.trigger = Y.trigger;
				OUT.data = Y.data;
				external_event[1] = change(OUT.acks);
			end Sender;
			
		end Sender_PKG;
		
		package Receiver_PKG
		
			record StateRec
				parameter Integer capacity;
				discrete Real next_TS;
				discrete Real data[capacity];
				Integer acks;
				Boolean first_event;
			end StateRec;
			
			record InputVariables_XRec
				Integer trigger;
				Integer data;
			end InputVariables_XRec;
			
			record OutputVariables_YRec
				Integer acks;
			end OutputVariables_YRec;
		
			block Receiver
				extends Atomic_PKG.Atomic(redeclare StateRec S(capacity = capacity), redeclare OutputVariables_YRec Y, redeclare InputVariables_XRec X, n_inputs = 1, n_outputs = 0, redeclare Boolean external_event[n_inputs]);
				InPort IN;
				parameter Real timeadvance = 3.0;
				parameter Integer capacity = 10;
			initial algorithm
				S.first_event := true;
				S.next_TS := Modelica.Constants.inf;
				next_TS := S.next_TS;
				/*for i in 1:size(S.data, 1) loop
					S.data[i] := 0;
				end for;*/
			algorithm
			//UPDATING next_TS
				when pre(transition_happened) then
					next_TS := S.next_TS "After every transition next_TS equals the value set into the state";
				end when;
			algorithm
				when pre(internal_transition_planned[1]) then //MAYBE A pre() HERE SHOULD PUT TOO
					Y.acks := S.acks;
				end when;
				/*when internal_transition_planned[2] then
					OUT.event_signal := Y.elements_processed;
					IN.event_request_signal := Y.request;
				end when;*/
			///////////////////////////////////////////////////////////////////////
			//                        TRANSITIONS CODE                           //
			///////////////////////////////////////////////////////////////////////
			algorithm
				when pre(confluent_transition) then
				//CONFLUENT TRANSITION CODE
					/*for i in 1:2000 loop
						S.data[capacity] := i;
					end for;*/
				elsewhen pre(external_transition) then
				//EXTERNAL TRANSITION CODE
					if S.first_event then
						/*for i in 1:size(S.data, 1) loop
							S.data[i] := 0;
						end for;*/
						S.first_event := false;
					end if "Let's see if in a first inizialition we can solve the Pantelides problem arising with a certain exploration of S.data independent by its size";
					if X.trigger > S.acks then
						S.acks := S.acks + 1;
						S.next_TS := -1;
					end if;
					if S.acks <= size(S.data, 1) then
						S.data[S.acks] := X.data;
					end if;
				elsewhen pre(internal_transition) then
				//INTERNAL TRANSITION CODE
					S.next_TS := Modelica.Constants.inf;
				end when;	
			///////////////////////////////////////////////////////////////////////
			//                     END OF TRANSITIONS CODE                       //
			///////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////
			//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
			///////////////////////////////////////////////////////////////////////
			//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables
			algorithm
				when pre(external_event) then
					X.trigger := pre(IN.trigger);
					X.data := pre(IN.data);
				end when;
			///////////////////////////////////////////////////////////////////////
			//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
			///////////////////////////////////////////////////////////////////////
			equation
				IN.acks = Y.acks;
				external_event[1] = change(IN.trigger);
				/*for i in 1:capacity loop
					S.data[i] = i;
				end for;*/
			end Receiver;
			
		end Receiver_PKG;
		
		package AutonomousArrayPKG
		
			record Data
				Integer ID;
			end Data;
		
			record StateAAr
				discrete Real next_TS;
				Data data[10];
			end StateAAr;
			
			record InputVariables_XAAr
				
			end InputVariables_XAAr;
			
			record OutputVariables_YAAr
				
			end OutputVariables_YAAr;
		
			block AutonomousArray
				extends Atomic_PKG.Atomic(redeclare StateAAr S, redeclare OutputVariables_YAAr Y, redeclare InputVariables_XAAr X, n_inputs = 0, n_outputs = 0, redeclare Boolean external_event[n_inputs]);
			initial algorithm
				S.next_TS := 0.7;
				next_TS := S.next_TS;
			algorithm
			//UPDATING next_TS
				when pre(transition_happened) then
					next_TS := S.next_TS "After every transition next_TS equals the value set into the state";
				end when;
			algorithm
				when pre(internal_transition_planned[1]) then //MAYBE A pre() HERE SHOULD PUT TOO
				
				end when;
				/*when internal_transition_planned[2] then
					OUT.event_signal := Y.elements_processed;
					IN.event_request_signal := Y.request;
				end when;*/
			///////////////////////////////////////////////////////////////////////
			//                        TRANSITIONS CODE                           //
			///////////////////////////////////////////////////////////////////////
			algorithm
				when pre(confluent_transition) then
				//CONFLUENT TRANSITION CODE
					/*for i in 1:2000 loop
						S.data[capacity] := i;
					end for;*/
				elsewhen pre(external_transition) then
				//EXTERNAL TRANSITION CODE
					
				elsewhen pre(internal_transition) then
				//INTERNAL TRANSITION CODE
					S.next_TS := Modelica.Constants.inf;
					for j in 1:size(S.data, 1) loop
						S.data[j].ID := j;
					end for;
					/*for i in 1:2000 loop
						S.data[capacity-1] := i;
					end for;*/
				end when;	
			///////////////////////////////////////////////////////////////////////
			//                     END OF TRANSITIONS CODE                       //
			///////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////
			//             INPUT RECORD X UPDATE AT EVENT ARRIVAL                //
			///////////////////////////////////////////////////////////////////////
			//To avoid algebraic loops the when should be activated by pre(external_event) and X variables should be assigned with pre() of connectors' variables
			algorithm
				when pre(external_event) then
					//X.trigger := pre(IN.trigger);
					//X.data := pre(IN.data);
				end when;
			///////////////////////////////////////////////////////////////////////
			//          END OF INPUT RECORD X UPDATE AT EVENT ARRIVAL            //
			///////////////////////////////////////////////////////////////////////
			equation
				
			end AutonomousArray;
		
		end AutonomousArrayPKG;
	
	end PDEVS_STRuctInfo;
	
	

end MODES;
