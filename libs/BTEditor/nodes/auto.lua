return {
	

	-- Composite
	["Composite"] = "muse.bt2.composite.",
	["Selector"] = "muse.bt2.composite.Selector",
  ["Sequence"] = "muse.bt2.composite.Sequence",
	["Parallel"] = "muse.bt2.composite.Parallel",
	["RandomSelector"] = "muse.bt2.composite.RandomSelector",
	["RandomSequence"] = "muse.bt2.composite.RandomSequence",
	["PrioritySelector"] = "muse.bt2.composite.PrioritySelector",

	-- Decorator
    ["Decorator"] = "muse.bt2.decorator.",
    ["Failure"] = "muse.bt2.decorator.Failure",
    ["Inverter"] = "muse.bt2.decorator.Inverter",
    ["Repeater"] = "muse.bt2.decorator.Repeater",
    ["Success"] = "muse.bt2.decorator.Success",
    ["UntilFailure"] = "muse.bt2.decorator.UntilFailure",
    ["UntilSuccess"] = "muse.bt2.decorator.UntilSuccess",

    -- Conditional
	  ["Conditional"] = "gameplay.behavior.conditional.",
	  ["RandomProbability"] = "muse.bt2.conditional.RandomProbability",

	-- Action
  	["Action"] = "gameplay.behavior.action.",
  	["Empty"] = "muse.bt2.action.Empty",
  	["Event"] = "muse.bt2.action.Event",
  	["Invoke"] = "muse.bt2.action.Invoke",
  	["Log"] = "muse.bt2.action.Log",
  	["Restart"] = "muse.bt2.action.Restart",
  	["Wait"] = "muse.bt2.action.Wait",

    -- tree
    ["SubTree"] = "gameplay.behavior.subtree.",
}