# Exercise 02: Build your store performance report

### Estimated Duration: 1.5 Hour(s)

## Scenario

The retail leadership team wants a single report page that quickly answers: which stores are performing best, how sales are trending over time, which product categories drive revenue, and how users can filter the view by date, region, and category. In this exercise, you will turn the cleaned model from Exercise 1 into an interactive Power BI Desktop dashboard.

## Overview

You will create one report page in Power BI Desktop using the local retail CSV model in `C:\LabFiles\PowerBI-Retail`. You will add a title, KPI cards, sales-by-store and sales-over-time charts, a store/category table or matrix, optional map visual, slicers, drill-down behavior, visual interactions, and beginner-friendly formatting. You will continue working in the same Power BI Desktop file that you started in Exercise 1.

## Objectives

- Task 1: Open the prepared report and set up the dashboard canvas
- Task 2: Add KPI cards for total sales, units sold, and top store
- Task 3: Create sales-by-store and sales-trend visuals
- Task 4: Add a store and category comparison matrix
- Task 5: Add an optional map visual when location fields are available
- Task 6: Add slicers and page filters
- Task 7: Configure cross-filtering and drill-down
- Task 8: Apply final formatting and save your work

## Task 1: Open the prepared report and set up the dashboard canvas

In this task, you will open your Power BI Desktop file and prepare one report page for the store performance dashboard.

1. Sign in to the lab VM using the credentials provided by your instructor or the CloudLabs environment.

2. If you are prompted to sign in to Azure or Microsoft services during the lab, use the following lab credentials:

   - Username: `<inject key="AzureAdUserEmail"></inject>`
   - Password: `<inject key="AzureAdUserPassword"></inject>`

   > [!Note]
   > The core lab is completed in Power BI Desktop. Publishing to the Power BI service is optional and is not required for this exercise.

3. Open the lab folder from the desktop shortcut, or browse to:

   `C:\LabFiles\PowerBI-Retail`

4. Open **Power BI Desktop**.

5. Open the report file you created in Exercise 1. If you have not saved one yet, select **File** > **Open report** and open your working `.pbix` file from `C:\LabFiles\PowerBI-Retail`.

6. Confirm that the following tables appear in the **Data** pane:

   - `Sales`
   - `Stores`
   - `Products`
   - `Dates`

7. Select **Report view** from the left navigation bar.

8. If the report already has a blank page, use it. Otherwise, select the **+** button at the bottom of Power BI Desktop to add a new report page.

9. Rename the page tab to **Store Performance**:

   1. Right-click the page tab.
   2. Select **Rename Page**.
   3. Enter `Store Performance`.

10. Add a report title:

    1. On the ribbon, select **Insert** > **Text box**.
    2. Type `Store Performance Dashboard`.
    3. Move the text box to the top-left of the canvas.
    4. Increase the font size to approximately **24-28 pt**.

11. Add a smaller subtitle below the title:

    `Deployment: <inject key="DeploymentID" enableCopy="false"></inject> | Retail CSV model`

    > [!Tip]
    > Including the deployment ID helps your instructor identify the report created in your specific lab environment.

12. Save your work by selecting **File** > **Save**.

## Task 2: Add KPI cards for total sales, units sold, and top store

In this task, you will add simple KPI cards across the top of the report. These cards give report readers the headline metrics before they inspect the detailed charts.

1. Click a blank area of the report canvas so no visual is selected.

2. In the **Visualizations** pane, select the **Card** visual.

3. With the card selected, drag `Sales[SalesAmount]` into the card's data field well.

4. If the card shows **Sum of SalesAmount**, keep it for this exercise. In Exercise 3, you will replace implicit totals with named DAX measures.

5. Format the first card:

   1. With the card selected, open **Format visual**.
   2. Turn **Title** on.
   3. Set the title text to `Total Sales`.
   4. Format the value as currency if it is not already displayed as currency.

6. Resize the card and place it under the title on the left side of the page.

7. Add a second **Card** visual for units sold:

   1. Select a blank area of the canvas.
   2. Select **Card**.
   3. Drag `Sales[Quantity]` or `Sales[Units]` into the data field well. Use the quantity/units column that exists in your `Sales` table.
   4. Set the card title to `Units Sold`.
   5. Place it next to the **Total Sales** card.

8. Add a third KPI card for the top store name:

   1. Select a blank area of the canvas.
   2. Select **Card**.
   3. Drag `Stores[StoreName]` into the data field well.
   4. In the field well, if Power BI summarizes the value, change the summarization to **First** or **Don't summarize** when available.
   5. Set the card title to `Top Store`.

   > [!Note]
   > This beginner version displays a store name based on the current filter context. In Exercise 3, you may create a more precise DAX measure, such as store rank or top store sales.

9. Arrange the three cards in a row across the top of the report page.

10. Save your work.

## Task 3: Create sales-by-store and sales-trend visuals

In this task, you will create the two main charts for the dashboard: a bar chart that compares stores and a line chart that shows the sales trend over time.

### Create a sales-by-store bar chart

1. Select a blank area in the middle-left of the report canvas.

2. In the **Visualizations** pane, select **Clustered bar chart**.

3. Add fields to the visual:

   - **Y-axis**: `Stores[StoreName]`
   - **X-axis**: `Sales[SalesAmount]`

4. Resize the chart so it occupies the left-middle section of the dashboard.

5. Sort the chart by sales:

   1. Select the chart.
   2. Select **More options** (`...`) in the chart header.
   3. Select **Sort axis** > `Sum of SalesAmount`.
   4. Select **Sort descending** so the highest-selling stores appear at the top.

6. Update the chart title:

   1. Open **Format visual**.
   2. Expand **General** > **Title**.
   3. Set the title text to `Sales by Store`.

7. Turn on data labels if they are not already visible:

   1. Open **Format visual**.
   2. Expand **Visual** > **Data labels**.
   3. Turn **Data labels** on.

### Create a sales-over-time line chart

8. Select a blank area in the middle-right of the report canvas.

9. In the **Visualizations** pane, select **Line chart**.

10. Add fields to the visual:

    - **X-axis**: `Dates[Date]`, `Dates[Month]`, or `Dates[MonthName]`
    - **Y-axis**: `Sales[SalesAmount]`

11. If Power BI creates a date hierarchy automatically, keep the hierarchy for now. It will help you practice drill-down later in this exercise.

12. Resize the line chart so it sits to the right of the bar chart.

13. Sort the line chart chronologically:

    1. Select the chart.
    2. Select **More options** (`...`).
    3. Select **Sort axis**.
    4. Choose the date or month field.
    5. Select **Sort ascending**.

14. Set the chart title to `Sales Trend`.

15. Save your work.

## Task 4: Add a store and category comparison matrix

In this task, you will add a table or matrix that allows report readers to compare store sales by product category.

1. Select a blank area in the lower-left section of the canvas.

2. In the **Visualizations** pane, select **Matrix**.

3. Add fields to the matrix:

   - **Rows**: `Stores[StoreName]`
   - **Columns**: `Products[Category]`
   - **Values**: `Sales[SalesAmount]`

4. If the matrix is too wide, use one of these beginner-friendly options:

   - Resize the matrix wider across the bottom of the page.
   - Remove `Products[Category]` from **Columns** and add it under `Stores[StoreName]` in **Rows**.
   - Use a **Table** visual instead with `Stores[StoreName]`, `Products[Category]`, `Sales[SalesAmount]`, and `Sales[Quantity]`.

5. Rename the visual title to `Store and Category Performance`.

6. Format the value as currency if needed:

   1. Select the `SalesAmount` field in the **Data** pane.
   2. On the ribbon, use **Column tools** or **Measure tools**.
   3. Set the format to **Currency**.

7. Select several rows in the matrix and observe how the other visuals respond. You will refine interactions in a later task.

8. Save your work.

## Task 5: Add an optional map visual when location fields are available

In this task, you will add a map visual if your `Stores` table includes location columns such as city, state, country/region, latitude, or longitude.

1. Check the `Stores` table in the **Data** pane for location fields. Common examples include:

   - `Stores[City]`
   - `Stores[State]`
   - `Stores[Region]`
   - `Stores[Country]`
   - `Stores[Latitude]`
   - `Stores[Longitude]`

2. If you have location fields, select a blank area in the lower-right section of the canvas.

3. In the **Visualizations** pane, select **Map**.

4. Add the available fields:

   - **Location**: `Stores[City]`, `Stores[State]`, or `Stores[Country]`
   - **Latitude**: `Stores[Latitude]`, if available
   - **Longitude**: `Stores[Longitude]`, if available
   - **Bubble size** or **Size**: `Sales[SalesAmount]`
   - **Legend**: `Stores[Region]`, if available

5. Set the map title to `Sales by Store Location`.

6. If the map visual does not display because maps are disabled in your Power BI Desktop settings, skip the map and create a **Donut chart** instead:

   - **Legend**: `Stores[Region]`
   - **Values**: `Sales[SalesAmount]`
   - Title: `Sales by Region`

   > [!Note]
   > Map visuals require map and geocoding features to be enabled in Power BI Desktop. The alternate donut chart keeps the dashboard useful even if map features are unavailable in your lab VM.

7. Save your work.

## Task 6: Add slicers and page filters

In this task, you will add interactive slicers so report readers can focus the dashboard by date, region, and product category.

1. Select a blank area near the top or right side of the report canvas.

2. In the **Visualizations** pane, select **Slicer**.

3. Create a date slicer:

   1. Drag `Dates[Date]`, `Dates[Month]`, or `Dates[MonthName]` into the slicer field well.
   2. Open **Format visual**.
   3. Expand **Visual** > **Slicer settings**.
   4. Choose a style that fits your page, such as **Between** for dates or **Dropdown** for months.
   5. Set the title to `Date` or `Month`.

4. Create a region slicer:

   1. Select a blank area of the canvas.
   2. Select **Slicer**.
   3. Drag `Stores[Region]` into the slicer.
   4. Set the slicer style to **Dropdown** if there are many regions, or **Tile** if there are only a few.
   5. Set the title to `Region`.

5. Create a product category slicer:

   1. Select a blank area of the canvas.
   2. Select **Slicer**.
   3. Drag `Products[Category]` into the slicer.
   4. Set the slicer style to **Dropdown**, **Vertical list**, or **Tile**.
   5. Set the title to `Category`.

6. Test the slicers:

   1. Select one region.
   2. Select one product category.
   3. Confirm that the cards, charts, matrix, and map or donut chart update.
   4. Clear the slicer selections when finished.

7. Add a page-level filter if needed:

   1. Open the **Filters** pane.
   2. Drag `Sales[SalesAmount]` or a similar field into **Filters on this page**.
   3. Use the filter only if you need to remove blank, zero, or test rows from the report page.

8. Save your work.

## Task 7: Configure cross-filtering and drill-down

In this task, you will check how visuals interact with each other and enable drill-down on the sales trend when a date hierarchy is available.

### Configure visual interactions

1. Select the **Sales by Store** bar chart.

2. On the ribbon, select **Format** > **Edit interactions**.

3. Notice the small interaction icons that appear on the other visuals.

4. For each visual, choose the interaction that makes the report easiest to understand:

   - Use **Filter** for KPI cards, the matrix, and trend chart when selecting a store should narrow those visuals to the selected store.
   - Use **Highlight** only if you want the selected store to highlight part of another chart while still showing the total.
   - Use **None** for visuals that should not change when the bar chart is selected.

5. Select the **Category** slicer and repeat **Format** > **Edit interactions**.

6. Confirm that the category slicer filters the charts, cards, and matrix.

7. Select **Format** > **Edit interactions** again to turn interaction editing off.

### Enable drill-down on the sales trend

8. Select the **Sales Trend** line chart.

9. Confirm that the **X-axis** uses a hierarchy such as Year > Quarter > Month > Day. If it does not:

   1. In the **Data** pane, expand `Dates`.
   2. Add date hierarchy fields to the X-axis in order, such as `Dates[Year]`, `Dates[Month]`, and `Dates[Date]`.

10. With the line chart selected, use the drill controls in the visual header:

    - Select **Drill down** to turn drill mode on.
    - Select a point on the chart to drill from year to quarter or month.
    - Select **Go to the next level in the hierarchy** to move all points down one level.
    - Select **Drill up** to return to the previous level.

11. To make drill-down affect the whole page:

    1. Select the drillable line chart.
    2. On the ribbon, select **Format**.
    3. Under **Apply drill down filters to**, select **Entire page** if the option is available.

12. Test cross-filtering:

    1. Select a store in the **Sales by Store** chart.
    2. Select a category from the **Category** slicer.
    3. Drill the **Sales Trend** chart from year to month.
    4. Confirm that the KPI cards and matrix respond to your selections.

13. Clear all selections before continuing:

    - Select blank space on the report canvas.
    - Clear slicers by using their clear-filter icon.
    - Drill back up to the top level of the line chart.

14. Save your work.

## Task 8: Apply final formatting and save your work

In this task, you will make the report easier to read and prepare it for the DAX and evidence steps in Exercise 3.

1. Apply a consistent report theme:

   1. On the ribbon, select **View**.
   2. Choose a built-in theme with readable contrast, such as a simple light theme.

2. Align the visuals:

   1. Select a visual.
   2. Hold **Ctrl** and select the other visuals in the same row.
   3. Use **Format** > **Align** and **Distribute** if those options are available.

3. Use descriptive titles for every visual:

   - `Total Sales`
   - `Units Sold`
   - `Top Store`
   - `Sales by Store`
   - `Sales Trend`
   - `Store and Category Performance`
   - `Sales by Store Location` or `Sales by Region`

4. Format numbers so they are easy to scan:

   - Use currency formatting for sales.
   - Use whole-number formatting for units.
   - Use display units such as thousands or millions if values are large.

5. Add helpful labels:

   1. Select each chart.
   2. Open **Format visual**.
   3. Turn on **Data labels** where labels improve readability.
   4. Avoid labels when they make the chart crowded.

6. Check the layout as a report reader:

   1. Start at the title.
   2. Read the KPI cards.
   3. Review the store comparison chart.
   4. Review the sales trend.
   5. Use slicers to filter by month, region, and category.
   6. Confirm the matrix provides the detailed comparison behind the charts.

7. Save the report:

   1. Select **File** > **Save As**.
   2. Browse to `C:\LabFiles\PowerBI-Retail\Evidence`.
   3. Save the file as `StorePerformanceReport.pbix`.

   > [!Important]
   > Exercise 3 and the automated validations expect the final PBIX file to be saved at `C:\LabFiles\PowerBI-Retail\Evidence\StorePerformanceReport.pbix`.

8. Do not export the screenshot yet unless your instructor asks you to. You will finalize evidence files after adding DAX measures in Exercise 3.

## Summary

You built a single-page store performance dashboard in Power BI Desktop. The report now includes KPI cards, a store comparison bar chart, a sales trend line chart, a store/category matrix, optional location analysis, slicers, visual interactions, drill-down behavior, and clear formatting. In the next exercise, you will replace implicit aggregations with named DAX measures and save the final validation evidence.