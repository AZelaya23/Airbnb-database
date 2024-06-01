use my_schema;


select * from airbnb;

-- creating host table
CREATE TABLE host AS SELECT `host id`, id, host_identity_verified, `host name`, `calculated host listings count` 
FROM airbnb;

select * from host
limit 10;

alter table host 
rename column `host id` to HostID,
rename column host_identity_verified to Verified,
rename column `host name` to HostName,
rename column `calculated host listings count` to HostListingsCount;

select * from host 
limit 10;

-- creating pricing table
create table pricing as 
select id, price, `service fee`, `minimum nights`, `availability 365`
from airbnb;

select * from pricing
limit 10;

alter table pricing 
rename column `service fee` to ServiceFee,
rename column `minimum nights` to MinNights,
rename column `availability 365` to YearAvailabilty;

select * from pricing
limit 10;

-- creating location table

create table location as 
select id, `neighbourhood group`, neighbourhood, lat, `long`
from airbnb;

select * from location
limit 10;  

alter table location 
rename column `neighbourhood group` to NeighbourhoodGroup,
rename column `neighbourhood` to Neighbourhood,
rename column lat to Latitude,
rename column `long` to Longitude;

select * from location ; 

-- creating listing table 
create table listings as 
select id, `NAME`, `room type`, `Construction year`, cancellation_policy
from airbnb;

select * from listings
limit 10;

alter table listings
rename column `NAME` to ListingName,
rename column `room type` to ListingType,
rename column `Construction Year` to ConstructYear,
rename column cancellation_policy to CancelPolicy;

select * from listings 
limit 10; 


-- creating reviews table 
create table reviews as
select id, `number of reviews`, `last review`, `reviews per month`, `review rate number`
from airbnb;

select * from reviews
limit 100;

alter table reviews 
rename column `number of reviews` to AmountReviews,
rename column `last review` to LatestReview,
rename column `review rate number` to Rating;

select * from reviews
limit 10;

alter table reviews
drop column `reviews per month`;

select * from reviews;

-- CODE

-- PRICE FOR A MINIMUM NIGHT STAY

-- change price and ServiceFee to int
set sql_safe_updates = 0;

update pricing 
set price = replace(price, '$', '');
update pricing 
set ServiceFee = replace(ServiceFee, '$', '');
update pricing 
set price = replace(price, ',', '');

select * from pricing;

ALTER TABLE pricing
ADD COLUMN PriceInt INT;

UPDATE pricing
SET PriceInt = CAST(price AS signed);

select * from pricing;

ALTER TABLE pricing
ADD COLUMN ServiceInt INT;

UPDATE pricing
SET ServiceInt = CAST(ServiceFee AS signed);

select * from pricing;

-- calculating
ALTER TABLE pricing
ADD COLUMN MinPrice INT;

UPDATE pricing
SET MinPrice = (PriceInt * MinNights) + ServiceInt;

select * from pricing;

-- WHICH NEIGHBOURHOOD/GROUP IS THE MOST POPULAR
select * from location;

select Neighbourhood, count(Neighbourhood) as PropertiesHere
from location
group by Neighbourhood
order by PropertiesHere desc;

select NeighbourhoodGroup, count(NeighbourhoodGroup) as PropertiesHere
from location
group by NeighbourhoodGroup
order by PropertiesHere desc;

-- FROM REVIEWS
select * from reviews;

-- 	WHICH PROPERTIES HAVE OVER 100 REVIEWS
select id, AmountReviews, Rating
from reviews
where AmountReviews > 99
order by AmountReviews desc;

-- WHICH PROPERTIES HAVE >100 AND AT ELAST 4 STARS
select id, AmountReviews, Rating
from reviews
where AmountReviews > 99
having Rating >3
order by AmountReviews desc;

-- casting the date to date type
select LatestReview from reviews;

UPDATE reviews
SET LatestReview = STR_TO_DATE(LatestReview, '%m/%d/%Y')
WHERE STR_TO_DATE(LatestReview, '%m/%d/%Y') IS NOT NULL;

ALTER TABLE reviews
MODIFY LatestReview DATE; 

-- HOW MANY REVIEWS PER MONTH
SELECT MONTH(LatestReview) AS Month, COUNT(*) AS Count
FROM reviews
GROUP BY MONTH(LatestReview)
ORDER BY COUNT(*) DESC;



