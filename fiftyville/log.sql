-- Keep a log of any SQL queries you execute as you solve the mystery.

--FOUND INFO
--crime: Theft of the CS50 duck took place at 10:15am at the Humphrey Street bakery. Interviews were conducted today with three witnesses
         --who were present at the time – each of their interview transcripts mentions the bakery.
--interviews:1.Raymond: As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket. |
            --Eugene:I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's bakery,
                   --I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.
            --Ruth: Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away.
                --If you have security footage from the bakery parking lot, you might want to look for cars that left the parking lot in that time frame.
--possible ppl list:

--find crime scene-
select *
from crime_scene_reports as csr
where street = 'Humphrey Street' AND csr.year= 2021 AND csr.month= 7 AND csr.day =28
limit 1

--seek interviewed ppl
select *
from
    interviews
where
    interviews.year= 2021 AND interviews.month= 7 AND interviews.day =28 and transcript like "%bakery%"

--interv.hint car
select activity, license_plate, bsl.hour, bsl.minute
from
    bakery_security_logs as bsl
where
    bsl.year= 2021 AND bsl.month= 7 AND bsl.day =28 and activity = "exit" and bsl.hour = 10

--intev hint atm
select account_number
from atm_transactions as atm
where atm_location = "Leggett Street" and atm.year=2021 and atm.month = 7 and atm.day = 28 and transaction_type = "withdraw"

-- suspects
select a.*, p.name
from atm_transactions a
join bank_accounts b on a.account_number = b.account_number
join people p on b.person_id = p.id
where a.atm_location = "Leggett Street" and a.year=2021 and a.month = 7 and a.day = 28 and a.transaction_type = "withdraw"

--phone calls by Raymond´s info
select people.id, people.name, people.passport_number, people.license_plate
from phone_calls as pc
join people on pc.caller = people.phone_number
where pc.year=2021 and pc.month = 7 and pc.day = 28 and pc.duration <= 60

--explore ariports - find fiftyville (id: 8)
select id
from airports
where city = "Fiftyville"

--find destination place =>  LaGuardia Airport (id: 36)
select f.*, origin.full_name as origin_airport, destination.full_name as destination_airport
from flights f
join airports origin on f.origin_airport_id = origin.id
join airports destination on f.destination_airport_id = destination.id
where origin.id = 8 and f.year = 2021 and f.month = 7 and f.day = 29
order by f.hour, f.minute

--narrow down suspects
select p.name
from bakery_security_logs bs
join people p on p.license_plate = bs.license_plate
join bank_accounts ba on ba.person_id = p.id
join atm_transactions at on at.account_number = ba.account_number
join phone_calls pc on pc.caller = p.phone_number
where bs.year = 2021 and bs.month = 7 and bs.day = 28 and bs.hour = 10 and bs.minute between 15 and 25
and at.atm_location = "Leggett Street" and at.year = 2021 and at.month = 7 and at.day = 28 and at.transaction_type = "withdraw"
and pc.year = 2021 and pc.month = 7 and pc.day = 28 and pc.duration < 60

--find person => the theth is Bruce
select name
from people p
join passengers ps on p.passport_number = ps.passport_number
where ps.flight_id = 36 and p.name in ("Bruce", "Diana")

--find acompliance => Robin
select p2.name as receiver
from phone_calls pc
join people p1 on pc.caller = p1.phone_number
join people p2 on pc.receiver = p2.phone_number
where p1.name = "Bruce" and pc.year = 2021 and pc.month = 7 and pc.day = 28
and pc.duration <60