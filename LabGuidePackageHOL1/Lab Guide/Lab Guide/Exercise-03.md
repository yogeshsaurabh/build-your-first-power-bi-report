# Exercise 03: Add your first DAX measure

### Estimated Duration: 60 minutes

## Scenario

Your Store Performance report already looks good, but leadership has two follow-up questions: what is Contoso's total sales across the current selection, and what share of total sales does each store or category contribute? Both are one-line DAX measures. In this exercise, you will write your first two DAX measures, use them in the report, validate the report, and save the required evidence files.

## Overview

You will:

- Create a `Total Sales` measure that sums sales amount.
- Create a `% of Total Sales` measure that divides current context sales by the grand total.
- Use these measures in the KPI card and the store × category table.
- Validate the report renders correctly.
- Save the final PBIX, the DAX text file, and a report screenshot to the Evidence folder.

## Objectives

- Task 1: Create a Total Sales measure
- Task 2: Create a % of Total Sales measure
- Task 3: Validate and save your single-page report

## Task 1: Create a Total Sales measure

In this task, you will create a proper DAX measure for total sales. Until now you have used **implicit measures** — the automatic sum Power BI creates when you drag a numeric column into a visual. Explicit measures are named, reusable, and appear in the field list.

1. On the lab VM, open Power BI Desktop and open the report:

   ```text
   C:\LabFiles\StorePerformanceReport.pbix
   ```
   ![](../media/E3T1S1-1.png)

2. In the **Data** pane on the right, right-click the **`Sales` (1)** table name and select **New measure (2)**.

   > [!Tip]
   > Right-clicking the table you want the measure to live in ensures the measure appears under that table in the field list.

   ![](../media/E3T1S2.png)

3. In the formula bar at the top of the report, replace the placeholder text with:

   ```dax
   Total Sales = SUM(Sales[SalesAmount])
   ```
   ![](../media/E3T1S3.png)

4. Press **Enter** or select the **✓** checkmark to commit the measure.

   ![](../media/E3T1S4.png)

5. Format the measure as currency:

   - In the **Data** pane, select the new **`Total Sales`(1)** measure (it appears under `Sales` with a calculator icon).
   - On the ribbon, select **Measure tools (2)**.
   - Set **Format** to **Currency (3)** and choose your preferred currency symbol.
   - Set **Decimal places** to **`0` (4)** (or `2` if you want cents).

     ![](../media/E3T1S5.png)

6. Use the new measure in the KPI card:

   - Select the **Total Sales (1)** card at the top of the page.
   - In the **Fields** well, remove the existing **`Sum of SalesAmount`(2)** field.
   - Drag **`Sales[Total Sales]`(3)** (the new measure) into the **Fields** well.

     ![](../media/E3T1S6-1.png)

     ![](../media/E3T1S6.png)

   The card value should be the same as before, but it now uses your explicit measure — which is the professional pattern.

7. Save the report — **Ctrl+S**. After saving the report the report looks like below.

   ![](../media/E3T1S7.png)

## Task 2: Create a % of Total Sales measure

In this task, you will create a measure that returns each row's share of total sales. You will then add it to the store × category table so viewers can see contribution percentages.

1. In the **Data** pane, right-click the **`Sales`(1)** table and select **New measure (2)**.

   ![](../media/E3T1S2.png)

2. In the formula bar, enter:

   ```dax
   % of Total Sales =
   DIVIDE(
       [Total Sales],
       CALCULATE([Total Sales], ALL(Sales), ALL(Stores), ALL(Products), ALL(Dates))
   )
   ```
   ![](../media/E3T2S2.png)

3. Press **Enter** or select the **✓** checkmark to commit the measure.

   > [!Note]
   > `DIVIDE` handles divide-by-zero safely (it returns blank instead of an error). `ALL(...)` on the fact table and each dimension removes filters from those tables in the denominator so it always returns the grand total.

   ![](../media/E3T2S3.png)

4. Format the measure as a percentage:

   - Select the new **`% of Total Sales`(1)** measure.
   - On the **Measure tools (2)** ribbon, set **Format** to **Percentage (3)**.
   - Set **Decimal places (4)** to `1`.

     ![](../media/E3T2S4.png)

5. Add the measure to the store × category table:

   - Select the **Store × Category Sales (1)** table visual on the page.
   - In the **Data** pane, drag **`Sales[% of Total Sales]` (2)** into the **Columns** well of the table.

     ![](../media/E3T2S5-1.png)

     ![](../media/E3T2S5-2.png)

6. In the table, each row now shows the share that store/category combination contributes to the total sales. Confirm the percentages sum to 100% when there is no filter applied.

   > [!Tip]
   > If you filter by region using the slicer, `Total Sales` recalculates for the filter but `% of Total Sales` still divides by the **overall** total (because of `ALL(...)`). If you want the percentage to reset to 100% within the current selection, change the denominator to use `ALLSELECTED(...)` instead of `ALL(...)`.

     ![](../media/E3T2S6.png)

7. Save the report — **Ctrl+S**.

   ![](../media/E3T2S7.png)

## Task 3: Validate and save your single-page report

In this task, you will do a final visual walkthrough of the report, then save the three required evidence files: the final PBIX, the DAX measures text file, and a screenshot or PDF of the report.

### Visual validation

1. Clear all slicers so no filter is applied.

   ![](../media/E3T3S1.png)

2. Confirm the three KPI cards show numbers, not errors or blanks.

   ![](../media/E3T3S2.png)

3. Confirm the bar chart shows all eight Contoso stores sorted by descending sales.

   ![](../media/E3T3S3.png)

4. Confirm the line chart shows a trend from January 2025 to June 2025.

   ![](../media/E3T3S4.png)

5. Confirm the map shows eight store bubbles across the United States, sized by sales.

   ![](../media/E3T3S5.png)

6. Confirm the store × category table shows sales and % of total sales columns.

   ![](../media/E3T3S6.png)

7. Test each slicer:

   - Select `East` from the region slicer. The other visuals should filter to West stores.
   - Clear the region slicer.
   - Select `Electronics` from the category dropdown slicer. The other visuals should filter to Electronics products.
   - Clear the category slicer.
   - Drag the date range slicer to a narrower window (for example, March to May 2025). The trend should shorten.
   - Clear the date slicer.

     ![](../media/E3T3S7-1.png)

8. Test cross-filtering by clicking a bar in the bar chart. The other visuals should filter.

9. Clear all filters by selecting the empty area on the page.

   ![](../media/E3T3S9.png)

### Save the final PBIX

1. Select **File** > **Save As**.

   ![](../media/E3T301.png)

   ![](../media/E3T302.png)

2. Confirm the file path is:

   ```text
   C:\LabFiles\PowerBI-Retail\Evidence\StorePerformanceReport.pbix
   ```

   If Power BI Desktop asks you to overwrite the existing file, select **Yes**.
   
   ![](../media/E3T303.png)

### Save the DAX measures text file

1. On the lab VM, open **Notepad** (or another text editor).

   ![](../media/E3T304.png)

2. Copy the two measure definitions into it:

   ```dax
   Total Sales = SUM(Sales[SalesAmount])

   % of Total Sales =
   DIVIDE(
       [Total Sales],
       CALCULATE([Total Sales], ALL(Sales), ALL(Stores), ALL(Products), ALL(Dates))
   )
   ```

   ![](../media/E3T305.png)

3. Select **File** > **Save As**.

   ![](../media/E3T306.png)

4. Save to:

   ```text
   C:\LabFiles\DAXMeasures.txt
   ```

   - **Save as type**: **All files**.
   - **File name**: `DAXMeasures.txt`.
   - **Encoding**: **UTF-8**.

      ![](../media/E3T307.png)

### Save a report PDF export

Choose one of the following options.

**Option A: PDF export**

1. In Power BI Desktop, select **File** > **Export** > **Export to PDF**.

   ![](../media/E3T301.png)

   ![](../media/E3T311.png)

2. Wait for the export to complete.

3. When the PDF opens in the default viewer, select **File** > **Save As** (or use the browser's download prompt) and save it as:

   ```text
   C:\LabFiles\PowerBI-Retail\Evidence\StorePerformanceReport.pdf
   ```
   ![](../media/E3T312.png)

### Confirm the evidence folder

1. Open **File Explorer** and go to:

   ```text
   C:\LabFiles\
   ```
   ![](../media/E3T315.png)

2. Confirm all three files are present and non-empty:

   - `StorePerformanceReport.pbix`
   - `DAXMeasures.txt`
   - `StorePerformanceReport.pdf`
   
3. Keep this folder available — the three evidence files complete this lab.

## Summary

In this exercise you wrote your first two DAX measures. `Total Sales = SUM(Sales[SalesAmount])` gave you an explicit, reusable total. `% of Total Sales` used `DIVIDE` and `ALL(...)` to compute each row's contribution to the grand total. You validated the report interactively, saved the final PBIX, exported a screenshot or PDF, and captured the DAX definitions in a text file. All three evidence files are in `C:\LabFiles\PowerBI-Retail\Evidence`.