-- CLEANING DATA PROJECT 
-- 1. REMOVE DUPLICATED 
-- 2. STANDARIZE THE DATA 
-- 3. NULL VALUES OR BLANK VALUES 
-- 4. REMOVE COLOM AND ROWS 
-- ____________________________________________________________


SELECT *
FROM layoffs;

 
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs ;

SELECT *
FROM layoffs_staging;

-- 1. remove duplicate 

SELECT *,
ROW_NUMBER() OVER (PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging ;


WITH duplicate_cte AS 
( 
SELECT *,
ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging 
)
SELECT * 
FROM duplicate_cte 
WHERE row_num > 1 ;

-- i just wanna make sure its really duplicates
SELECT *
FROM layoffs_staging
WHERE company = 'casper';


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
SELECT *
FROM layoffs_staging2;

-- inserting the data
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging ;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- remove or delete the duplicate
DELETE
FROM layoffs_staging2
WHERE row_num > 1 ;
 
SELECT *
FROM layoffs_staging2;

-- ______________________________________________________________
-- 2. stadarizing data 


-- trim the spaces
SELECT company, TRIM(company)
FROM layoffs_staging2; 


UPDATE layoffs_staging2
SET company = TRIM(company);



 
SELECT DISTINCT industry
FROM layoffs_staging2;

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1 ;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';


-- update the cryto currency into crpyto to standarize the label 
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


-- to make sure if there is something more to updated 
SELECT DISTINCT location 
FROM layoffs_staging2
ORDER BY 1 ;

SELECT DISTINCT country 
FROM layoffs_staging2
ORDER BY 1 ;
-- updated in coutry colom 
SELECT DISTINCT country 
FROM layoffs_staging2
WHERE country LIKE 'United States%';
-- trim trailing 
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country )
FROM layoffs_staging2 
ORDER BY 1 ;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country )
WHERE country LIKE 'United States%' ;
 


-- update the DATE into DATE value and not text value
SELECT `date`
FROM layoffs_staging2;
--  STR_TO _DATE
SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2;
-- update to the table 
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y') ;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date`DATE ;
-- and the data type is sucsess fully 

SELECT *
FROM layoffs_staging2;

-- ________________________________________________________________________________________________________________________________

-- 3. NULL VALUES OR BLAK VALUES 
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL ;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '' ;
-- _________________
-- update the BLANK INTO NULL 
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '' ;
-- ________________________________
-- populated null values
 
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';



SELECT t1.industry, t2.industry 
FROM layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;



 
UPDATE layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
SET t1.industry = t2.industry 
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;
-- now the null values in industry colom is populated 
 
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL OR industry = '' ;


-- ______________________________________________________________

-- 4. REMOVE COLUMS 


-- REMOVING THE  total_laid_off IS NULL and percentage_laid_off IS NULL 
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL ;




-- REMOVING THOSE COLOMS 
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL ;



SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL ;


SELECT * 
FROM layoffs_staging2 ;

-- DELETING THE ROW NUM COLOM BECAUSE WE DONT NEED IT ANYMORE 

SELECT * 
FROM layoffs_staging2 
WHERE row_num > 1 ;


-- DROP THE row_num colom BY DOING ALTER table
ALTER TABLE layoffs_staging2
DROP COLUMN row_num ;


SELECT * 
FROM layoffs_staging2 
ORDER BY company ;