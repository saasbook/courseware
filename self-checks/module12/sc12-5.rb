quiz "12.5: Monitoring and Finding Bottlenecks" do
	choice_answer do
		text "Which is probably NOT a metric of high interest to you, the app operator?"
		answer "Maximum CPU utilization"
		distractor "Slowest queries"
		distractor "99 percentile response time"
		distractor "Rendering time of 3 slowest views"
		explanation "As an operator, you should focus on metrics that directly impact the customer. While CPU utilization may be related to the other metrics, unless you know for certain that it's the root cause of poor behavior in those other metrics, you should instead focus on understanding why the other metrics are poor."
	end
end