set sql_mode = '';
SELECT 
	s1.cancelled_date as "original canceled date",
    s2.cancelled_date as "resurected canceled date",
	s1.created_date as "original create date",
    s2.created_date as "resurected create date",
	s1.end_date as "original end date",
    s2.end_date as "resurected end date",
	s1.next_charge_date as "original next charge date",
    s2.next_charge_date as "resurected next charge date",
    case
		when s1.subscription_type = 0 then 'Monthly'
        when s1.subscription_type = 2 then 'Annual'
        when s1.subscription_type = 3 then 'Lifetime'
	end as 'original plan',
     case
		when s2.subscription_type = 0 then 'Monthly'
        when s2.subscription_type = 2 then 'Annual'
        when s2.subscription_type = 3 then 'Lifetime'
	end as 'resurected plan',
    datediff(cast(s2.created_date as date),cast(s1.end_date as date)) as 'days to resurection',
    s1.student_id,
    s1.subscription_id as 'original subscription id',
     s2.subscription_id as 'resurected subscription id'
        
FROM
    customer_churn.subscriptions s1
    join
    subscriptions s2 on ( s1.student_id = s2.student_id and s1.subscription_id != s2.subscription_id and s2.subscription_id > s1.subscription_id 
    and s2.created_date > s1.created_date)
    where s1.state =3
    and datediff(cast(s2.created_date as date),cast(s1.end_date as date)) >1 
    group by s1.student_id
    ;