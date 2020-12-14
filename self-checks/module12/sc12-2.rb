quiz "12.2: Three-Tier Architecture" do
	choice_answer do
		text "The master-slave configuration is appropriate for applications that experience what kind of workload?"
		answer "Read heavy"
		distractor "Write heavy"
		distractor "Equal distribution of read and write operations"
		distractor "None, the configuration doesn't affect how the workload is handled"
		explanation "The master/slave configuration is a communication model where the master has control over multiple slave devices and load balances requests across the slave devices. Another distinction between master and slave is that while any slave can perform a read, only the master can perform writes. The master must also update slaves with the writes' results. Therefore, when faced with a write-heavy workload, this configuration becomes increasingly inefficient because a single server will be burdened with the majority of the work."
	end
end