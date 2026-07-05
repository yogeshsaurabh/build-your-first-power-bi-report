# Exercise 03: Add your first DAX measures and finalize

### Estimated Duration: 1 Hour

## Scenario

Your retail report already contains cleaned CSV data, relationships, and a one-page store performance dashboard. In this exercise, you will make the report more useful by creating your first DAX measures, using those measures in visuals, and saving the files that the lab validation checks expect to find.

## Overview

You will create beginner-friendly measures for total sales, total units, percentage of total sales, and an optional top-store calculation. You will then use the measures in the report page, confirm that the values respond to slicers, save the final `.pbix` file, export evidence, and copy your measure definitions into a text file.

## Objectives

- Task 1: Reopen the lab workspace and confirm the report is ready
- Task 2: Create the `Total Sales` and `Total Units` measures
- Task 3: Create the `% of Total Sales` measure
- Task 4: Add an optional top store measure
- Task 5: Apply the measures and validate the report behavior
- Task 6: Save the PBIX file and report evidence
- Task 7: Save `DAXMeasures.txt` and run validations

## Task 1: Reopen the lab workspace and confirm the report is ready

In this task, you will return to the Power BI Desktop file and confirm the expected local lab folders are available.

1. If you are reconnecting to the lab environment, sign in with the lab credentials provided for this environment:

   - Username: `<inject key="AzureAdUserEmail"></inject>`
   - Password: `<inject key="AzureAdUserPassword"></inject>`

2. If you need to identify your assigned lab deployment, use **deployment <inject key="DeploymentID" enableCopy="false"/>**.

3. Open **File Explorer** and browse to the lab folder:

   ```text
   C:\LabFiles\PowerBI-Retail
   ```

4. Confirm that the following files and folder exist:

   ```text
   C:\LabFiles\PowerBI-Retail\Sales.csv
   C:\LabFiles\PowerBI-Retail\Stores.csv
   C:\LabFiles\PowerBI-Retail\Products.csv
   C:\LabFiles\PowerBI-Retail\Dates.csv
   C:\LabFiles\PowerBI-Retail\Evidence
   ```

5. Open **Power BI Desktop**.

6. If your report is already open, continue to the next task. If it is not open, select **File** > **Open report** > **Browse reports**, and open the report you created in the previous exercise.

7. In the **Data** pane, confirm that you can see the four tables:

   - `Sales`
   - `Stores`
   - `Products`
   - `Dates`

8. Select **Home** > **Refresh**. Wait for the refresh to finish without errors.

> [!Tip]
> If refresh fails because a CSV file path changed, use **Transform data** > **Data source settings** to point the query back to `C:\LabFiles\PowerBI-Retail`.

## Task 2: Create the `Total Sales` and `Total Units` measures

In this task, you will create two basic DAX measures. Measures are reusable calculations that recalculate automatically when you interact with report visuals, slicers, and filters.

1. In Power BI Desktop, select the **Report** view.

2. In the **Data** pane, right-click the `Sales` table, and then select **New measure**.

3. In the formula bar, replace the default measure text with the following DAX formula:

   ```dax
   Total Sales = SUM(Sales[SalesAmount])
   ```

4. Press **Enter** or select the **Commit** check mark in the formula bar.

5. Confirm that `Total Sales` appears under the `Sales` table with a calculator icon.

6. Select the `Total Sales` measure in the **Data** pane.

7. On the ribbon, use the formatting options to set the measure as currency:

   - **Format**: Currency
   - **Decimal places**: 0 or 2, depending on your preference

8. Right-click the `Sales` table again, and then select **New measure**.

9. In the formula bar, enter the following DAX formula:

   ```dax
   Total Units = SUM(Sales[Quantity])
   ```

10. Press **Enter** or select the **Commit** check mark.

11. If your `Sales` table uses a different units column name, update the formula to match your table. Common alternatives are:

   ```dax
   Total Units = SUM(Sales[UnitsSold])
   ```

   or

   ```dax
   Total Units = SUM(Sales[Units])
   ```

12. Confirm that `Total Units` appears under the `Sales` table with a calculator icon.

> [!Important]
> The validation later in this exercise checks the text file you create. The measure names should be exactly `Total Sales` and `Total Units`, even if your column names differ.

## Task 3: Create the `% of Total Sales` measure

In this task, you will create a percentage measure that compares the current store or category sales to the total sales across stores. This measure uses `DIVIDE` to handle divide-by-zero safely and `ALL` to remove the current store filter when calculating the denominator.

1. In the **Data** pane, right-click the `Sales` table, and then select **New measure**.

2. In the formula bar, enter the following DAX formula:

   ```dax
   % of Total Sales =
   DIVIDE(
       [Total Sales],
       CALCULATE([Total Sales], ALL(Stores))
   )
   ```

3. Press **Enter** or select the **Commit** check mark.

4. Select the `% of Total Sales` measure in the **Data** pane.

5. On the ribbon, set the format to **Percentage**.

6. Set **Decimal places** to `1` or `2`.

7. Add a temporary **Table** visual to a blank area of the report page.

8. Add the following fields to the temporary table:

   - `Stores[StoreName]`
   - `Total Sales`
   - `% of Total Sales`

9. Confirm that each store has a percentage value.

10. Select different values in your date, region, or product category slicers. Confirm that `Total Sales` and `% of Total Sales` recalculate.

> [!Note]
> This version of `% of Total Sales` removes filters from the `Stores` table only. That means date and product category slicers can still affect the result, which is useful when you want to compare each store against the current filtered business context.

<question>

## Task 4: Add an optional top store measure

In this task, you will add an optional measure that identifies the store with the highest sales in the current filter context. This is useful for a KPI card or a short executive summary on the report page.

1. In the **Data** pane, right-click the `Sales` table, and then select **New measure**.

2. In the formula bar, enter the following DAX formula:

   ```dax
   Top Store =
   CONCATENATEX(
       TOPN(
           1,
           VALUES(Stores[StoreName]),
           [Total Sales],
           DESC
       ),
       Stores[StoreName],
       ", "
   )
   ```

3. Press **Enter** or select the **Commit** check mark.

4. Add a **Card** visual to the report page.

5. Add the `Top Store` measure to the card.

6. Rename the visual title to `Top Store`.

7. Select different slicer values and confirm that the top store can change when the filter context changes.

> [!Tip]
> If two stores are tied, the measure can return more than one store name. That is acceptable for this beginner report.

## Task 5: Apply the measures and validate the report behavior

In this task, you will replace automatically summarized columns with your explicit measures and check that the report behaves interactively.

1. Select the card visual that shows total sales.

2. In the **Visualizations** pane, remove the existing summarized sales field if one is present.

3. Drag the `Total Sales` measure into the card visual.

4. Confirm the card title is clear, such as `Total Sales`.

5. Select the card visual that shows units sold.

6. Replace the existing summarized units field with the `Total Units` measure.

7. Confirm the card title is clear, such as `Units Sold`.

8. Select your clustered bar chart for sales by store.

9. Make sure the visual uses:

   - **Y-axis** or **Axis**: `Stores[StoreName]`
   - **X-axis** or **Values**: `Total Sales`

10. Select your line chart for sales over time.

11. Make sure the visual uses:

   - **X-axis**: a date, month, or month-year field from `Dates`
   - **Y-axis** or **Values**: `Total Sales`

12. Select your table or matrix visual.

13. Add `% of Total Sales` to the visual so you can compare each store or category with the total.

14. Test interactions:

   - Select a single store in the bar chart.
   - Select a product category slicer value.
   - Select a date or month slicer value.
   - Confirm the cards, line chart, and table/matrix update.

15. If a visual does not update, select the visual that should control filtering, and then select **Format** > **Edit interactions**. Make sure the target visual is set to **Filter** or **Highlight**, not **None**.

16. Remove the temporary table visual if you no longer need it.

> [!Important]
> The goal is not just to create formulas. The goal is to show that your measures respond to report context, including slicers and cross-filtering.

## Task 6: Save the PBIX file and report evidence

In this task, you will save the final report and export visual evidence to the `Evidence` folder used by the validation checks.

1. Select **File** > **Save as**.

2. Browse to the following folder:

   ```text
   C:\LabFiles\PowerBI-Retail\Evidence
   ```

3. Save the report with the exact file name:

   ```text
   StorePerformanceReport.pbix
   ```

4. Confirm the full file path is:

   ```text
   C:\LabFiles\PowerBI-Retail\Evidence\StorePerformanceReport.pbix
   ```

5. Export a PDF copy of the report page:

   1. Select **File** > **Export** > **Export to PDF**.
   2. Wait for the export process to finish.
   3. If the PDF opens in Microsoft Edge or another PDF viewer, select **Save as**.
   4. Save the file in the `Evidence` folder with the exact file name:

      ```text
      StorePerformanceReport.pdf
      ```

6. If PDF export is not available, create an image instead:

   1. Open the report page in Power BI Desktop.
   2. Open **Snipping Tool** from the Windows Start menu.
   3. Capture the full report canvas.
   4. Save the image in the `Evidence` folder as one of the following file names:

      ```text
      StorePerformanceReport.png
      ```

      or

      ```text
      StorePerformanceReport.jpg
      ```

7. Open **File Explorer** and confirm that the `Evidence` folder contains the PBIX file and at least one report evidence file:

   ```text
   C:\LabFiles\PowerBI-Retail\Evidence\StorePerformanceReport.pbix
   C:\LabFiles\PowerBI-Retail\Evidence\StorePerformanceReport.pdf
   ```

   or

   ```text
   C:\LabFiles\PowerBI-Retail\Evidence\StorePerformanceReport.png
   ```

<validation step="PBIX file validation"/>

<validation step="Report screenshot/export validation"/>

## Task 7: Save `DAXMeasures.txt` and run validations

In this task, you will copy your measure definitions into a text file so the automated validation can check that your final DAX includes the required beginner patterns.

1. Open **Notepad**.

2. Copy the final measure definitions you created into Notepad.

3. Your file should include at least the following measures. If you used a different units column name, keep your working version of the `Total Units` formula.

   ```dax
   Total Sales = SUM(Sales[SalesAmount])

   Total Units = SUM(Sales[Quantity])

   % of Total Sales =
   DIVIDE(
       [Total Sales],
       CALCULATE([Total Sales], ALL(Stores))
   )

   Top Store =
   CONCATENATEX(
       TOPN(
           1,
           VALUES(Stores[StoreName]),
           [Total Sales],
           DESC
       ),
       Stores[StoreName],
       ", "
   )
   ```

4. Save the text file with the exact path and file name:

   ```text
   C:\LabFiles\PowerBI-Retail\Evidence\DAXMeasures.txt
   ```

5. In **File Explorer**, open the `Evidence` folder and confirm it contains these files:

   ```text
   StorePerformanceReport.pbix
   DAXMeasures.txt
   StorePerformanceReport.pdf
   ```

   If you saved an image instead of a PDF, confirm the folder contains `StorePerformanceReport.png` or `StorePerformanceReport.jpg`.

6. Open `DAXMeasures.txt` and confirm it includes the exact measure names:

   - `Total Sales`
   - `Total Units`
   - `% of Total Sales`

7. Confirm the text includes these DAX patterns:

   - `SUM`
   - `DIVIDE`
   - `ALL`

8. Save and close `DAXMeasures.txt`.

<validation step="DAX measure text validation"/>

## Summary

In this exercise, you created explicit DAX measures for total sales, total units, percentage of total sales, and an optional top-store KPI. You applied the measures to your report visuals, tested slicer and cross-filter behavior, saved the final PBIX file, exported report evidence, and created `DAXMeasures.txt` for validation. Your first single-page Power BI store performance report is now complete.
