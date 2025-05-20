function FSM() constructor {
    current = undefined;
    states = {};
    state_time = 0;


    add = function(name, state_struct) {
	    state_struct.fsm = self; // Inject FSM reference into the state
	    variable_struct_set(states, name, state_struct);
	}


    set = function(name) {
        if (current != undefined && variable_struct_exists(current, "on_exit")) {
			if(is_callable(current.on_exit)) {
				current.on_exit();
			}
        }

        if (variable_struct_exists(states, name)) {
            current = variable_struct_get(states, name);
            state_time = 0;

			if(variable_struct_exists(current, "on_enter")) {
	            if (is_callable(current.on_enter)) {
	                current.on_enter();
	            }
			}
        } else {
            show_debug_message("FSM Error: State '" + string(name) + "' does not exist.");
        }
    }

    step = function() {
        state_time += 1;

        if (current != undefined && !is_undefined(current.step)) {
            current.step(state_time);
        }
    }
}
