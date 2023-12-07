use Property;

set IMPLICIT_TRANSACTIONS ON;

 /* Price Part */
 -- Add a new column 'Prices' with Numeric(18,2) datatype to the 'lists' table
ALTER TABLE lists
ADD Prices Numeric(18,2);


-- Remove 'R' and spaces from the 'Price' column
UPDATE lists
SET Price = REPLACE(REPLACE(Price, 'R', ''), ' ', '');

/*Looking Price that start with any letter or contains letters and prices
which are null from our price column  and deleting them */
DELETE FROM lists
WHERE Price LIKE '[A-Za-z]%' Or Price is null

-- Convert the 'Price' column to Numeric(18,2) and 
--	And set the results to the prices column  to be able to
-- change the datatype to numeric to be able to perform  calculations
UPDATE lists
SET Prices = CAST(Price AS NUMERIC(18,2));

--Doing the same things as the Price columns
ALTER TABLE lists
ADD new_levies NUMERIC(18,2);

-- Remove 'R' and spaces from the 'Levies' column and update the 'new_levies' column
UPDATE lists
SET Levies = REPLACE(REPLACE(Levies, 'R', ''), ' ', '');

UPDATE lists
SET new_levies = CAST(Levies AS NUMERIC(18,2));


ALTER TABLE lists
ADD [New Rates and Taxes] NUMERIC(18,2);

-- Remove 'R' and spaces from the '[Rates and Taxes]' column
UPDATE lists
SET [Rates and Taxes] = REPLACE(REPLACE([Rates and Taxes], 'R', ''), ' ', '');


UPDATE lists
SET [New Rates and Taxes] = CAST([Rates and Taxes] AS NUMERIC(18,2));

.
/* Erf Size */
 alter table lists
 add [new Erf Size] numeric(18,2)

update lists
set [erf size] = Replace([erf size], ' ', '')

--Since our column have  different  units we are converting them to one units so we
-- can have consistency in our table
--We are converting ha to ma. Now all our rows  are in ma units
UPDATE lists
SET [new Erf Size]=( 
CASE 
WHEN CHARINDEX('ha', [Erf Size]) > 0 
THEN cast(SUBSTRING([Erf Size], 1, CHARINDEX('ha', [Erf Size]) - 1) AS DECIMAL(18,2)) * 10000
else CAST(SUBSTRING([Erf Size], 1, CHARINDEX('mÂ²', [Erf Size]) - 1) AS DECIMAL(18,2))
 END)

update lists
set [new floor size] =(
case when 
Charindex('ha', [floor size])>0
then Cast(substring([floor size], 1, charindex('ha', [floor size]) - 1) as numeric(18,2)) * 10000
else Cast(substring([floor size], 1, charindex('mÂ²', [floor size]) - 1) as numeric(18,2))
end)


--Checking row where there is nulls and return unknown where there is nulls
--We assume that we are not sure if pets are allowed in the area or not
update lists
set  [Pets Allowed Y/N] = (coalesce([Pets Allowed Y/N], 'Unknown'))



-- Remove multiple columns from the 'lists' table which
--we recreated when we were cleaning our data
ALTER TABLE lists
DROP COLUMN place,
DROP COLUMN [Erf Size],
DROP COLUMN [floor size],
DROP COLUMN lifestyle,
DROP COLUMN price;

commit

select  * from lists
