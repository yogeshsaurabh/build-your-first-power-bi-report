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

2. In the **Data** pane on the right, right-click the `Sales` table name and select **New measure**.

   > [!Tip]
   > Right-clicking the table you want the measure to live in ensures the measure appears under that table in the field list.

3. In the formula bar at the top of the report, replace the placeholder text with:

   ```dax
   Total Sales = SUM(Sales[SalesAmount])
   ```

4. Press **Enter** or select the **✓** checkmark to commit the measure.

5. Format the measure as currency:

   - In the **Data** pane, select the new `Total Sales` measure (it appears under `Sales` with a calculator icon).
   - On the ribbon, select **Measure tools**.
   - Set **Format** to **Currency** and choose your preferred currency symbol.
   - Set **Decimal places** to `0` (or `2` if you want cents).

6. Use the new measure in the KPI card:

   - Select the **Total Sales** card at the top of the page.
   - In the **Fields** well, remove the existing `SalesAmount` field.
   - Drag `Sales[Total Sales]` (the new measure) into the **Fields** well.

   The card value should be the same as before, but it now uses your explicit measure — which is the professional pattern.

7. Save the report — **Ctrl+S**.

## Task 2: Create a % of Total Sales measure

In this task, you will create a measure that returns each row's share of total sales. You will then add it to the store × category table so viewers can see contribution percentages.

1. In the **Data** pane, right-click the `Sales` table and select **New measure**.

2. In the formula bar, enter:

   ```dax
   % of Total Sales =
   DIVIDE(
       [Total Sales],
       CALCULATE([Total Sales], ALL(Sales), ALL(Stores), ALL(Products), ALL(Dates))
   )
   ```

3. Press **Enter** to commit.

   > [!Note]
   > `DIVIDE` handles divide-by-zero safely (it returns blank instead of an error). `ALL(...)` on the fact table and each dimension removes filters from those tables in the denominator so it always returns the grand total.

4. Format the measure as a percentage:

   - Select the new `% of Total Sales` measure.
   - On the **Measure tools** ribbon, set **Format** to **Percentage**.
   - Set **Decimal places** to `1`.

5. Add the measure to the store × category table:

   - Select the **Store × Category Sales** table visual on the page.
   - In the **Data** pane, drag `Sales[% of Total Sales]` into the **Columns** well of the table.

6. In the table, each row now shows the share that store/category combination contributes to the total sales. Confirm the percentages sum to 100% when there is no filter applied.

   > [!Tip]
   > If you filter by region using the slicer, `Total Sales` recalculates for the filter but `% of Total Sales` still divides by the **overall** total (because of `ALL(...)`). If you want the percentage to reset to 100% within the current selection, change the denominator to use `ALLSELECTED(...)` instead of `ALL(...)`.

7. Save the report — **Ctrl+S**.

## Task 3: Validate and save your single-page report

In this task, you will do a final visual walkthrough of the report, then save the three required evidence files: the final PBIX, the DAX measures text file, and a screenshot or PDF of the report.

### Visual validation

1. Clear all slicers so no filter is applied.

2. Confirm the three KPI cards show numbers, not errors or blanks.

3. Confirm the bar chart shows all eight Contoso stores sorted by descending sales.

4. Confirm the line chart shows a trend from January 2025 to June 2025.

5. Confirm the map shows eight store bubbles across the United States, sized by sales.

6. Confirm the store × category table shows sales and % of total sales columns.

7. Test each slicer:

   - Select `West` from the region slicer. The other visuals should filter to West stores.
   - Clear the region slicer.
   - Select `Electronics` from the category dropdown slicer. The other visuals should filter to Electronics products.
   - Clear the category slicer.
   - Drag the date range slicer to a narrower window (for example, March to May 2025). The trend should shorten.
   - Clear the date slicer.

8. Test cross-filtering by clicking a bar in the bar chart. The other visuals should filter.

9. Clear all filters by selecting the empty area on the page.

### Save the final PBIX

1. Select **File** > **Save As**.

2. Confirm the file path is:

   ```text
   C:\LabFiles\PowerBI-Retail\Evidence\StorePerformanceReport.pbix
   ```

   If Power BI Desktop asks you to overwrite the existing file, select **Yes**.

### Save the DAX measures text file

1. On the lab VM, open **Notepad** (or another text editor).

2. Copy the two measure definitions into it:

   ```dax
   Total Sales = SUM(Sales[SalesAmount])

   % of Total Sales =
   DIVIDE(
       [Total Sales],
       CALCULATE([Total Sales], ALL(Sales), ALL(Stores), ALL(Products), ALL(Dates))
   )
   ```

3. Select **File** > **Save As**.

4. Save to:

   ```text
   C:\LabFiles\PowerBI-Retail\Evidence\DAXMeasures.txt
   ```

   - **Save as type**: **All files**.
   - **File name**: `DAXMeasures.txt`.
   - **Encoding**: **UTF-8**.

### Save a report screenshot or PDF export

Choose one of the following options.

**Option A: Screenshot (PNG)**

1. In Power BI Desktop, arrange your report page so it fills the canvas cleanly.

2. Press **Windows key** + **Shift** + **S** to open the Snipping Tool.

3. Drag to capture the report page area.

4. In the Snipping Tool notification, open the capture and save it as:

   ```text
   C:\LabFiles\PowerBI-Retail\Evidence\StorePerformanceReport.png
   ```

**Option B: PDF export**

1. In Power BI Desktop, select **File** > **Export** > **Export to PDF**.

2. Wait for the export to complete.

3. When the PDF opens in the default viewer, select **File** > **Save As** (or use the browser's download prompt) and save it as:

   ```text
   C:\LabFiles\PowerBI-Retail\Evidence\StorePerformanceReport.pdf
   ```

### Confirm the evidence folder

1. Open **File Explorer** and go to:

   ```text
   C:\LabFiles\PowerBI-Retail\Evidence
   ```

2. Confirm all three files are present and non-empty:

   - `StorePerformanceReport.pbix`
   - `DAXMeasures.txt`
   - `StorePerformanceReport.png` (or `.pdf` or `.jpg`)

3. Keep this folder available — the three evidence files complete this lab.

## Summary

In this exercise you wrote your first two DAX measures. `Total Sales = SUM(Sales[SalesAmount])` gave you an explicit, reusable total. `% of Total Sales` used `DIVIDE` and `ALL(...)` to compute each row's contribution to the grand total. You validated the report interactively, saved the final PBIX, exported a screenshot or PDF, and captured the DAX definitions in a text file. All three evidence files are in `C:\LabFiles\PowerBI-Retail\Evidence`.