
-- Exploratry data Analysis 
select * from layoff_staging2;

select max(total_laid_off) as max_laid_off,
max(percentage_laid_off) as max_percentage_laid_off 
from layoff_staging2
where percentage_laid_off is not null;

select * from layoff_staging2 
where percentage_laid_off=1;

select * from layoff_staging2 
where percentage_laid_off=1
order by funds_raised_millions desc;

select company,sum(total_laid_off)
from layoff_staging2
group by company
order by 2 desc;


select company,sum(total_laid_off)
from layoff_staging2
group by company  
order by 2 desc
limit 5;

select location,sum(total_laid_off)
from layoff_staging2 
group by location 
order by 2 desc
limit 10;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 ASC;


SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;
select min(`date`),max(`date`)
from layoff_staging2;

select industry,sum(total_laid_off)
from layoff_staging2
group by industry
order by 2 desc;

select `date`,sum(total_laid_off)
from layoff_staging2
group by `date`
order by `date` ;

select year(`date`),sum(total_laid_off)
from layoff_staging2
group by year(`date`)
order by 2 desc;

WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;


-- Rolling Total of Layoffs Per Month
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC;

-- now use it in a CTE so we can query off of it
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;


