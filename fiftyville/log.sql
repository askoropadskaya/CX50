-- Keep a log of any SQL queries you execute as you solve the mystery.

SELECT description
FROM crime_scene_reports
WHERE month = 7
AND day = 28
AND street = 'Humphrey Street';
-- | Theft of the CS50 duck took place at 10:15am at the Humphrey Street bakery. Interviews were conducted today with three witnesses
--who were present at the time – each of their interview transcripts mentions the bakery. |
--| Littering took place at 16:36. No known witnesses.

SELECT *
FROM interviews
WHERE month = 7
AND day = 28
AND transcript LIKE '%thief%' OR '%thref%';

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| id  |  name   | year | month | day |                                                                                                                                                     transcript                                                                                                                                                      |
+-----+---------+------+-------+-----+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| 161 | Ruth    | 2021 | 7     | 28  | Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away. If you have security footage from the bakery parking lot, you might want to look for cars that left the parking lot in that time frame.                                                          |
| 162 | Eugene  | 2021 | 7     | 28  | I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's bakery, I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.                                                                                                 |
| 163 | Raymond | 2021 | 7     | 28  | As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket. |
+-----+---------+------+-------+-----+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM bakery_security_logs
WHERE day = 28
AND month = 7
AND hour >= 10
AND minute > 15 AND minute <= 25
AND activity = 'exit'
ORDER BY minute;

+-----+------+-------+-----+------+--------+----------+---------------+
| id  | year | month | day | hour | minute | activity | license_plate |
+-----+------+-------+-----+------+--------+----------+---------------+
| 260 | 2021 | 7     | 28  | 10   | 16     | exit     | 5P2BI95       |
| 282 | 2021 | 7     | 28  | 15   | 16     | exit     | 94MV71O       |
| 289 | 2021 | 7     | 28  | 17   | 16     | exit     | V47T75I       |
| 261 | 2021 | 7     | 28  | 10   | 18     | exit     | 94KL13X       |
| 262 | 2021 | 7     | 28  | 10   | 18     | exit     | 6P58WS2       |
| 280 | 2021 | 7     | 28  | 14   | 18     | exit     | NAW9653       |
| 290 | 2021 | 7     | 28  | 17   | 18     | exit     | R3G7486       |
| 263 | 2021 | 7     | 28  | 10   | 19     | exit     | 4328GD8       |
| 264 | 2021 | 7     | 28  | 10   | 20     | exit     | G412CB7       |
| 265 | 2021 | 7     | 28  | 10   | 21     | exit     | L93JTIZ       |
| 266 | 2021 | 7     | 28  | 10   | 23     | exit     | 322W7JE       |
| 267 | 2021 | 7     | 28  | 10   | 23     | exit     | 0NTHK55       |
+-----+------+-------+-----+------+--------+----------+---------------+

SELECT *
FROM atm_transactions
WHERE atm_location = 'Leggett Street'
AND day = 28
AND month = 7
AND transaction_type = 'withdraw';

+-----+----------------+------+-------+-----+----------------+------------------+--------+
| id  | account_number | year | month | day |  atm_location  | transaction_type | amount |
+-----+----------------+------+-------+-----+----------------+------------------+--------+
| 246 | 28500762       | 2021 | 7     | 28  | Leggett Street | withdraw         | 48     |
| 264 | 28296815       | 2021 | 7     | 28  | Leggett Street | withdraw         | 20     |
| 266 | 76054385       | 2021 | 7     | 28  | Leggett Street | withdraw         | 60     |
| 267 | 49610011       | 2021 | 7     | 28  | Leggett Street | withdraw         | 50     |
| 269 | 16153065       | 2021 | 7     | 28  | Leggett Street | withdraw         | 80     |
| 288 | 25506511       | 2021 | 7     | 28  | Leggett Street | withdraw         | 20     |
| 313 | 81061156       | 2021 | 7     | 28  | Leggett Street | withdraw         | 30     |
| 336 | 26013199       | 2021 | 7     | 28  | Leggett Street | withdraw         | 35     |
+-----+----------------+------+-------+-----+----------------+------------------+--------+

SELECT *
FROM phone_calls
WHERE day = 28
AND month = 7
AND duration < 60;

+-----+----------------+----------------+------+-------+-----+----------+
| id  |     caller     |    receiver    | year | month | day | duration |
+-----+----------------+----------------+------+-------+-----+----------+
| 221 | (130) 555-0289 | (996) 555-8899 | 2021 | 7     | 28  | 51       |
| 224 | (499) 555-9472 | (892) 555-8872 | 2021 | 7     | 28  | 36       |
| 233 | (367) 555-5533 | (375) 555-8161 | 2021 | 7     | 28  | 45       |
| 251 | (499) 555-9472 | (717) 555-1342 | 2021 | 7     | 28  | 50       |
| 254 | (286) 555-6063 | (676) 555-6554 | 2021 | 7     | 28  | 43       |
| 255 | (770) 555-1861 | (725) 555-3243 | 2021 | 7     | 28  | 49       |
| 261 | (031) 555-6622 | (910) 555-3251 | 2021 | 7     | 28  | 38       |
| 279 | (826) 555-1652 | (066) 555-9701 | 2021 | 7     | 28  | 55       |
| 281 | (338) 555-6650 | (704) 555-2131 | 2021 | 7     | 28  | 54       |
+-----+----------------+----------------+------+-------+-----+----------+

SELECT person_id
FROM bank_accounts
WHERE account_number IN (
    SELECT account_number
    FROM atm_transactions
    WHERE atm_location = 'Leggett Street'
    AND day = 28
    AND month = 7
    AND transaction_type = 'withdraw'
);

+-----------+
| person_id |
+-----------+
| 686048    |
| 514354    |
| 458378    |
| 395717    |
| 396669    |
| 467400    |
| 449774    |
| 438727    |
+-----------+

--two possible thieves are:

SELECT *
FROM people
JOIN bank_accounts ON people.id = bank_accounts.person_id
WHERE person_id IN (
    SELECT person_id
    FROM bank_accounts
    WHERE account_number IN (
        SELECT account_number
        FROM atm_transactions
        WHERE atm_location = 'Leggett Street'
        AND day = 28
        AND month = 7
        AND transaction_type = 'withdraw'
    )
AND license_plate IN (
    SELECT license_plate
    FROM bakery_security_logs
    WHERE day = 28
    AND month = 7
    AND hour >= 10
    AND minute > 15 AND minute <= 25
    AND activity = 'exit'
    )
AND phone_number IN (
    SELECT caller
    FROM phone_calls
    WHERE day = 28
    AND month = 7
    AND duration < 60
    )
);

+--------+-------+----------------+-----------------+---------------+----------------+-----------+---------------+
|   id   | name  |  phone_number  | passport_number | license_plate | account_number | person_id | creation_year |
+--------+-------+----------------+-----------------+---------------+----------------+-----------+---------------+
| 686048 | Bruce | (367) 555-5533 | 5773159633      | 94KL13X       | 49610011       | 686048    | 2010          |
| 514354 | Diana | (770) 555-1861 | 3592750733      | 322W7JE       | 26013199       | 514354    | 2012          |
+--------+-------+----------------+-----------------+---------------+----------------+-----------+---------------+

Those two were talking to:

SELECT receiver
FROM phone_calls
WHERE caller IN(
    SELECT phone_number
    FROM people
    JOIN bank_accounts ON people.id = bank_accounts.person_id
    WHERE person_id IN (
        SELECT person_id
        FROM bank_accounts
        WHERE account_number IN (
            SELECT account_number
            FROM atm_transactions
            WHERE atm_location = 'Leggett Street'
            AND day = 28
            AND month = 7
            AND transaction_type = 'withdraw'
        )
    AND license_plate IN (
        SELECT license_plate
        FROM bakery_security_logs
        WHERE day = 28
        AND month = 7
        AND hour >= 10
        AND minute > 15 AND minute <= 25
        AND activity = 'exit'
    )
    AND phone_number IN (
        SELECT caller
        FROM phone_calls
        WHERE day = 28
        AND month = 7
        AND duration < 60
    )
    )
)
AND day = 28
AND month = 7
AND duration < 60;

+----------------+
|    receiver    |
+----------------+
| (375) 555-8161 |
| (725) 555-3243 |
+----------------+

+-----+----------------+----------------+------+-------+-----+----------+
| id  |     caller     |    receiver    | year | month | day | duration |
+-----+----------------+----------------+------+-------+-----+----------+
| 233 | (367) 555-5533 | (375) 555-8161 | 2021 | 7     | 28  | 45       |
| 255 | (770) 555-1861 | (725) 555-3243 | 2021 | 7     | 28  | 49       |
+-----+----------------+----------------+------+-------+-----+----------+

--What are * including person_id of those two:

SELECT *
FROM people
WHERE phone_number IN (
    SELECT receiver
FROM phone_calls
WHERE caller IN(
    SELECT phone_number
    FROM people
    JOIN bank_accounts ON people.id = bank_accounts.person_id
    WHERE person_id IN (
        SELECT person_id
        FROM bank_accounts
        WHERE account_number IN (
            SELECT account_number
            FROM atm_transactions
            WHERE atm_location = 'Leggett Street'
            AND day = 28
            AND month = 7
            AND transaction_type = 'withdraw'
        )
    AND license_plate IN (
        SELECT license_plate
        FROM bakery_security_logs
        WHERE day = 28
        AND month = 7
        AND hour >= 10
        AND minute > 15 AND minute <= 25
        AND activity = 'exit'
    )
    AND phone_number IN (
        SELECT caller
        FROM phone_calls
        WHERE day = 28
        AND month = 7
        AND duration < 60
    )
    )
)
AND day = 28
AND month = 7
AND duration < 60);

+--------+--------+----------------+-----------------+---------------+
|   id   |  name  |  phone_number  | passport_number | license_plate |
+--------+--------+----------------+-----------------+---------------+
| 847116 | Philip | (725) 555-3243 | 3391710505      | GW362R6       |
| 864400 | Robin  | (375) 555-8161 | NULL            | 4V16VO0       |
+--------+--------+----------------+-----------------+---------------+

--Id of Aipropt in Fiftyville

SELECT *
FROM airports
WHERE city = 'Fiftyville';

+----+--------------+-----------------------------+------------+
| id | abbreviation |          full_name          |    city    |
+----+--------------+-----------------------------+------------+
| 8  | CSF          | Fiftyville Regional Airport | Fiftyville |
+----+--------------+-----------------------------+------------+

SELECT *
FROM flights
WHERE origin_airport_id = (
    SELECT id
    FROM airports
    WHERE city = 'Fiftyville'
)
AND month = 7
AND day = 29;

+----+-------------------+------------------------+------+-------+-----+------+--------+
| id | origin_airport_id | destination_airport_id | year | month | day | hour | minute |
+----+-------------------+------------------------+------+-------+-----+------+--------+
| 18 | 8                 | 6                      | 2021 | 7     | 29  | 16   | 0      |
| 23 | 8                 | 11                     | 2021 | 7     | 29  | 12   | 15     |
| 36 | 8                 | 4                      | 2021 | 7     | 29  | 8    | 20     |
| 43 | 8                 | 1                      | 2021 | 7     | 29  | 9    | 30     |
| 53 | 8                 | 9                      | 2021 | 7     | 29  | 15   | 20     |
+----+-------------------+------------------------+------+-------+-----+------+--------+

--What are those destination airports:
SELECT full_name, id
FROM airports
WHERE id IN(
    SELECT destination_airport_id
    FROM flights
    WHERE origin_airport_id = (
        SELECT id
        FROM airports
        WHERE city = 'Fiftyville'
)
AND month = 7
AND day = 29
);

+-------------------------------------+----+
|              full_name              | id |
+-------------------------------------+----+
| O'Hare International Airport        | 1  |
| LaGuardia Airport                   | 4  |
| Logan International Airport         | 6  |
| Tokyo International Airport         | 9  |
| San Francisco International Airport | 11 |
+-------------------------------------+----+

--Flight_id of passengers with passport number of receiver

SELECT *
FROM passengers
WHERE passport_number IN (
    SELECT passport_number
    FROM people
    WHERE phone_number IN (
        SELECT receiver
        FROM phone_calls
        WHERE caller IN(
            SELECT phone_number
            FROM people
            JOIN bank_accounts ON people.id = bank_accounts.person_id
            WHERE person_id IN (
                SELECT person_id
                FROM bank_accounts
                WHERE account_number IN (
                    SELECT account_number
                    FROM atm_transactions
                    WHERE atm_location = 'Leggett Street'
                    AND day = 28
                    AND month = 7
                    AND transaction_type = 'withdraw'
                )
    AND license_plate IN (
        SELECT license_plate
        FROM bakery_security_logs
        WHERE day = 28
        AND month = 7
        AND hour >= 10
        AND minute > 15 AND minute <= 25
        AND activity = 'exit'
    )
    AND phone_number IN (
        SELECT caller
        FROM phone_calls
        WHERE day = 28
        AND month = 7
        AND duration < 60
    )
    )
)
AND day = 28
AND month = 7
AND duration < 60)
);

+-----------+-----------------+------+
| flight_id | passport_number | seat |
+-----------+-----------------+------+
| 10        | 3391710505      | 2A   |
| 28        | 3391710505      | 2A   |
| 47        | 3391710505      | 4D   |
+-----------+-----------------+------+

SELECT *
FROM passengers
WHERE passport_number IN(
    SELECT passport_number
    FROM people
    JOIN bank_accounts ON people.id = bank_accounts.person_id
    WHERE person_id IN (
        SELECT person_id
        FROM bank_accounts
        WHERE account_number IN (
            SELECT account_number
            FROM atm_transactions
            WHERE atm_location = 'Leggett Street'
            AND day = 28
            AND month = 7
            AND transaction_type = 'withdraw'
        )
    AND license_plate IN (
        SELECT license_plate
        FROM bakery_security_logs
        WHERE day = 28
        AND month = 7
        AND hour >= 10
        AND minute > 15 AND minute <= 25
        AND activity = 'exit'
        )
    AND phone_number IN (
        SELECT caller
        FROM phone_calls
        WHERE day = 28
        AND month = 7
        AND duration < 60
        )
    )
);
+-----------+-----------------+------+
| flight_id | passport_number | seat |
+-----------+-----------------+------+
| 18        | 3592750733      | 4C   |
| 24        | 3592750733      | 2C   |
| 36        | 5773159633      | 4A   |
| 54        | 3592750733      | 6C   |
+-----------+-----------------+------+

SELECT *
FROM phone_calls
JOIN people ON phone_calls.caller = people.phone_number
WHERE caller IN(
    SELECT phone_number
    FROM people
    JOIN bank_accounts ON people.id = bank_accounts.person_id
    WHERE person_id IN (
        SELECT person_id
        FROM bank_accounts
        WHERE account_number IN (
            SELECT account_number
            FROM atm_transactions
            WHERE atm_location = 'Leggett Street'
            AND day = 28
            AND month = 7
            AND transaction_type = 'withdraw'
        )
    AND license_plate IN (
        SELECT license_plate
        FROM bakery_security_logs
        WHERE day = 28
        AND month = 7
        AND hour >= 10
        AND minute > 15 AND minute <= 25
        AND activity = 'exit'
    )
    AND phone_number IN (
        SELECT caller
        FROM phone_calls
        WHERE day = 28
        AND month = 7
        AND duration < 60
    )
    )
)
AND day = 28
AND month = 7
AND duration < 60;

+-----+----------------+----------------+------+-------+-----+----------+--------+-------+----------------+-----------------+---------------+
| id  |     caller     |    receiver    | year | month | day | duration |   id   | name  |  phone_number  | passport_number | license_plate |
+-----+----------------+----------------+------+-------+-----+----------+--------+-------+----------------+-----------------+---------------+
| 233 | (367) 555-5533 | (375) 555-8161 | 2021 | 7     | 28  | 45       | 686048 | Bruce | (367) 555-5533 | 5773159633      | 94KL13X       |
| 255 | (770) 555-1861 | (725) 555-3243 | 2021 | 7     | 28  | 49       | 514354 | Diana | (770) 555-1861 | 3592750733      | 322W7JE       |
+-----+----------------+----------------+------+-------+-----+----------+--------+-------+----------------+-----------------+---------------+


SELECT *
FROM flights
JOIN passengers ON flights.id = passengers.flight_id
WHERE passport_number IN (
        SELECT passport_number
        FROM people
        JOIN bank_accounts ON people.id = bank_accounts.person_id
        WHERE person_id IN (
            SELECT person_id
            FROM bank_accounts
            WHERE account_number IN (
                SELECT account_number
                FROM atm_transactions
                WHERE atm_location = 'Leggett Street'
                AND day = 28
                AND month = 7
                AND transaction_type = 'withdraw'
            )
        AND license_plate IN (
            SELECT license_plate
            FROM bakery_security_logs
            WHERE day = 28
            AND month = 7
            AND hour >= 10
            AND minute > 15 AND minute <= 25
            AND activity = 'exit'
            )
        AND phone_number IN (
            SELECT caller
            FROM phone_calls
            WHERE day = 28
            AND month = 7
            AND duration < 60
            )
        )
    OR passport_number IN (
            SELECT passport_number
            FROM people
            WHERE phone_number IN (
                SELECT receiver
                FROM phone_calls
                WHERE caller IN(
                    SELECT phone_number
                    FROM people
                    JOIN bank_accounts ON people.id = bank_accounts.person_id
                    WHERE person_id IN (
                        SELECT person_id
                        FROM bank_accounts
                        WHERE account_number IN (
                            SELECT account_number
                            FROM atm_transactions
                            WHERE atm_location = 'Leggett Street'
                            AND day = 28
                            AND month = 7
                            AND transaction_type = 'withdraw'
                        )
            AND license_plate IN (
                SELECT license_plate
                FROM bakery_security_logs
                WHERE day = 28
                AND month = 7
                AND hour >= 10
                AND minute > 15 AND minute <= 25
                AND activity = 'exit'
            )
            AND phone_number IN (
                SELECT caller
                FROM phone_calls
                WHERE day = 28
                AND month = 7
                AND duration < 60
            )

        )
        AND day = 28
        AND month = 7
        AND duration < 60)
        )
        )

)
AND origin_airport_id = 8
AND day = 29
AND month = 7;

+----+-------------------+------------------------+------+-------+-----+------+--------+-----------+-----------------+------+
| id | origin_airport_id | destination_airport_id | year | month | day | hour | minute | flight_id | passport_number | seat |
+----+-------------------+------------------------+------+-------+-----+------+--------+-----------+-----------------+------+
| 18 | 8                 | 6                      | 2021 | 7     | 29  | 16   | 0      | 18        | 3592750733      | 4C   |
| 36 | 8                 | 4                      | 2021 | 7     | 29  | 8    | 20     | 36        | 5773159633      | 4A   |
+----+-------------------+------------------------+------+-------+-----+------+--------+-----------+-----------------+------+

