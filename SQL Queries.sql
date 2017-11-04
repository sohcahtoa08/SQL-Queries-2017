# SQL QUERIES
####################################

# Most Common Case Type

SELECT SPLIT_PART(LOWER(SPLIT_PART(court_system, '- ', 2)), ' system', 1) as system, COUNT(court_system) AS count
FROM cases
GROUP BY system
ORDER BY count DESC
LIMIT 6;


# Criminals Who Committed Most Crimes

SELECT name, dob, COUNT(name)
FROM parties
JOIN charges ON charges.case_id = parties.case_id
WHERE (
	LOWER(disposition) LIKE '%guilty%'
	OR LOWER(plea) LIKE '%guilty%'
)
AND NULLIF(name, '') IS NOT NULL
AND LOWER(parties.type) LIKE '%defendant%'
GROUP BY name, dob
ORDER BY count DESC
LIMIT 10;


# ZIP Code With Most Criminals

SELECT zip, COUNT(zip) AS count
FROM parties
JOIN charges ON charges.case_id = parties.case_id
WHERE (
	LOWER(disposition) LIKE '%guilty%'
	OR LOWER(plea) LIKE '%guilty%'
)
GROUP BY zip
ORDER BY count DESC
LIMIT 10;


# Does Race Affect Verdict?

-- Verdicts for each race
SELECT race, disposition, COUNT(disposition) AS count
FROM (
	SELECT cases.case_id, parties.race, charges.disposition
	FROM cases
	JOIN parties ON cases.case_id = parties.case_id
	JOIN charges ON cases.case_id = charges.case_id
	WHERE NULLIF(parties.race, '') IS NOT NULL
	AND NULLIF(charges.disposition, '') IS NOT NULL
) AS dispositions
GROUP BY disposition, race
ORDER BY count DESC, race;

-- Total cases for each race
SELECT race, COUNT(race) AS count
FROM (
	SELECT cases.case_id, parties.race
	FROM cases
	JOIN parties ON cases.case_id = parties.case_id
	WHERE NULLIF(parties.race, '') IS NOT NULL
) AS races
GROUP BY race
ORDER BY count DESC, race;


# Does Gender Affect Verdict?

-- Verdicts for each gender
SELECT sex, disposition, COUNT(disposition) AS count
FROM (
	SELECT cases.case_id, parties.sex, charges.disposition
	FROM cases
	JOIN parties ON cases.case_id = parties.case_id
	JOIN charges ON cases.case_id = charges.case_id
	WHERE NULLIF(parties.sex, '') IS NOT NULL
	AND NULLIF(charges.disposition, '') IS NOT NULL
) AS dispositions
GROUP BY disposition, sex
ORDER BY count DESC;

-- Total cases for each gender
SELECT sex, COUNT(sex) AS count
FROM (
	SELECT cases.case_id, parties.sex
	FROM cases
	JOIN parties ON cases.case_id = parties.case_id
	WHERE NULLIF(parties.sex, '') IS NOT NULL
) AS sexes
GROUP BY sex
ORDER BY count DESC;



