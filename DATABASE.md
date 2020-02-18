ERROR 1419 (HY000) at line 9: You do not have the SUPER privilege and binary logging is enabled (you *might* want to use the less safe log_bin_trust_function_creators variable)

mysql -u USERNAME -p
set global log_bin_trust_function_creators=1;
