# Challenge 1: Build the dashboard

### Estimated Duration: 120 Minutes

## Overview

In this exercise, you will build a complete Power BI Sales Performance dashboard using a sample sales dataset. You will import and model data, create DAX measures, and design interactive report visuals. You will also apply themes and formatting to produce a professional, board-ready dashboard. Finally, you will validate the report to ensure it is accurate, interactive, and ready for business analysis.

## Objectives

In this exercise you will:

- Task 1: Review the brief and explore the dataset
- Task 2: Model the data
- Task 3: Create 3 KPIs
- Task 4: Create 2 charts and 1 slicer
- Task 5: Apply a theme

## Task 1: Review the brief and explore the dataset

In this task you will verify that the required CSV dataset files are available and populated with sample data before importing them into Power BI.

1. Open **File Explorer**, navigate to **C:\LabFiles**, and then open the **data** folder.

    ![](images/t1s1.png)

1. Verify that the generated dataset contains the required CSV files, including **Dim_Customer (1)**, **Dim_Date**, **Dim_Product**, **Dim_Region**, **Dim_SalesRep**, **Fact_Budget**, and **Fact_Sales**.

    ![](images/t1s2.png)

1. Open any of the generated CSV files, such as **Dim_Customer (1)**, in **Visual Studio Code** to verify that the dataset has been populated with sample records.

    ![](images/t1s3.png)

## Task 2: Model the data

In this task you will import the dataset into Power BI, create the required relationships, configure the date table and hierarchy, hide technical columns, and validate the data model.

1. On the desktop, double-click **Power BI Desktop** to launch the application.

    ![](images/t2s1.png)

1. On the **Power BI Desktop** start page, select **Blank report**.

    ![](images/t2s2.png)

1. From the **Home (1)** tab, select **Get data (2)**, and then choose **Text/CSV (3)**.

    ![](images/t2s3.png)

1. In the **Open** dialog box, navigate to **C:\LabFiles\data (1)**, select the **Dim_Customer.csv (2)** file, and then click **Open (3)**.

    ![](images/t2s4.png)

1. Review the preview of the **Dim_Customer.csv** file, and then select **Transform Data**.

    ![](images/t2s5.png)

1. Repeat the previous steps to import the remaining CSV files from the **C:\LabFiles\data** folder. Verify that all the tables are available in the **Data** pane.

    ![](images/t2s6.png)

1. In the left navigation pane, select the **Model** view to display the relationships between the imported tables.

    ![](images/t2s7.png)

1. Drag the **Date** column from the **Fact_Sales** table and drop it onto the **Date** column in the **Dim_Date** table to create a relationship.

    ![](images/t2s8.png)

1. In the **New relationship** dialog box, verify the following settings, and then select **Save**:
   - **From table**: Fact_Sales
   - **To table**: Dim_Date
   - **Cardinality**: **Many to one (*:1)**
   - **Cross-filter direction**: **Single**
   - Ensure **Make this relationship active** is selected.

     ![](images/t2s9.png)

1. Similarly perform the steps to map the relation as per below table.

     | From Table | From Column | To Table | To Column |
     |------------|-------------|----------|-----------|
     | Fact_Sales | RegionID | Dim_Region | RegionID |
     | Fact_Sales | ProductID | Dim_Product | ProductID |
     | Fact_Sales | CustomerID | Dim_Customer | CustomerID |
     | Fact_Sales | SalesRepID | Dim_SalesRep | SalesRepID |
     | Fact_Budget | RegionID | Dim_Region | RegionID |

1. Right-click the **Dim_Date (1)** table, and then select **Mark as date table (2)**.

    ![](images/t2s10.png)

1. In the **Mark as a date table** dialog box, ensure **Mark as a date table (1)** is enabled, verify **Date (2)** is selected as the date column, and then select **Save (3)**.

    ![](images/t2s11.png)

1. In the **Model** view, right-click the **Year (1)** column in the **Dim_Date** table, and then select **Create hierarchy (2)**.

    ![](images/t2s12.png)

1. Right-click the **Quarter (1)** column, select **Add to hierarchy (2)**, and then choose **Year Hierarchy (3)**.

    ![](images/t2s13.png)

1. Right-click the **MonthName (1)** column, select **Add to hierarchy (2)**, and then choose **Year Hierarchy (3)**.

    ![](images/t2s14.png)

1. Repeat the previous step to add the **YearMonth** column to the **Year Hierarchy**.

1. Select the **Report** view **(1)**, and verify that the newly created **Year Hierarchy (2)** is displayed under the **Dim_Date** table in the **Data** pane.

    ![](images/t2s15.png)

    > **Note:** Depending on your version of Power BI Desktop, the hierarchy may appear as **Year Hierarchy** or **Date Hierarchy**.

    ![](images/t2s16.png)

1. In the **Model** view, right-click the following columns in the **Fact_Sales** table, and then select **Hide in report view**:
   - **OrderID**
   - **RegionID**
   - **SalesRepID**

      ![](images/t2s17.png)

1. Verify that the hidden columns display the **hidden** icon in the **Fact_Sales** table.

    ![](images/t2s18.png)

1. Select the **Report** view **(1)**. In the **Data** pane, expand the **Dim_Region (2)** table and select **RegionID (3)**. Then expand the **Fact_Sales (4)** table and select **Revenue (5)** to create a table visual **(6)**.

    ![](images/t2s19.png)

1. Verify that the table visual displays the **RegionID** and the **Sum of Revenue** for each region.

    ![](images/t2s20.png)

## Task 3: Create 3 KPIs

In this task you will create DAX measures for key business metrics, format them appropriately, and display them as KPI cards with meaningful titles.

1. Select the **Modeling (1)** tab, and then select **New table (2)**.

    ![](images/t3s1.png)

1. In the formula bar, enter the following DAX expression, and then press **Enter**.

    ```DAX
    _Measures = ROW("Value", BLANK())
    ```

    ![](images/t3s2.png)

1. Verify that the **_Measures** table is created and appears in the **Data** pane.

    ![](images/t3s3.png)

1. Select the **_Measures (1)** table, and then on the **Modeling (2)** tab, select **New measure (3)**.

    ![](images/t3s4.png)

1. In the formula bar, enter the following DAX expression, and then press **Enter**.

    ```DAX
    Total Revenue = SUM(Fact_Sales[Revenue])
    ```

    ![](images/t3s5.png)

1. Verify that the **Total Revenue** measure is created under the **_Measures** table.

    ![](images/t3s6.png)

1. Select the **Total Revenue (1)** measure, open the **Format (2)** drop-down, and then select **Currency (3)**.

    ![](images/t3s7.png)

1. Select the **_Measures (1)** table, and then select **New measure (2)**.

    ![](images/t3s8.png)

1. In the formula bar, enter the following DAX expression, and then press **Enter**.

    ```DAX
    Gross Margin % =
        DIVIDE(
            [Total Revenue] - SUM(Fact_Sales[COGS]),
            [Total Revenue]
        )
    ```

    ![](images/t3s9.png)

1. Verify that the **Gross Margin %** measure is created under the **_Measures** table.

    ![](images/t3s10.png)

1. Select the **Gross Margin % (1)** measure. Change the **Format (2)** to **Percentage**, and set the decimal places to **1 (3)**.

    ![](images/t3s11.png)

1. Select the **_Measures (1)** table, and then select **New measure (2)**.

    ![](images/t3s12.png)

1. In the formula bar, enter the following DAX expression, and then press **Enter**.

    ```DAX
    Target Attainment % =
        DIVIDE(
            [Total Revenue],
            SUM(Fact_Budget[TargetRevenue])
        )
    ```

    ![](images/t3s13.png)

1. Verify that the **Target Attainment %** measure is created under the **_Measures** table.

    ![](images/t3s14.png)

1. Select the **Target Attainment % (1)** measure. Change the **Format (2)** to **Percentage**, and set the decimal places to **1 (3)**.

    ![](images/t3s15.png)

1. Select the **Card** visual **(1)**, drag the **Total Revenue** measure **(2)** to the visual, and verify that the card displays the total revenue **(3)**.

    ![](images/t3s16.png)

1. Verify that the report contains three **Card** visuals displaying **Total Revenue**, **Target Attainment %**, and **Gross Margin %**.

    ![](images/t3s17.png)

1. Select the **Total Revenue** card **(1)**. In the **Visualizations** pane, select the **Format visual (2)** option, expand the **Title (3)** section, turn **Title (4)** **On**, and set the title text to **Revenue (5)**.

    ![](images/t3s18.png)

1. Repeat the previous step for the remaining card visuals by setting the titles as follows:

    | Card Visual | Title |
    |--------------|-------|
    | Total Revenue | Revenue |
    | Target Attainment % | Target Attainment |
    | Gross Margin % | Gross Margin % |

    Verify that all three card visuals display the updated titles.

    ![](images/t3s19.png)

## Task 4: Create 2 charts and 1 slicer

In this task you will create charts and slicers, configure sorting and filtering, and format the visuals to build an interactive sales performance report.

1. On the **Home** tab, select **Transform data (1)** and then choose **Transform data (2)** to open **Power Query Editor**.

    ![](images/t4s1.png)

1. Create a line chart by selecting the **Line chart (1)** visual. From the **Data** pane, select **MonthName (2)** from the **Dim_Date** table and **Total Revenue (3)** from the **_Measures** table. Resize and position the chart below the KPI cards.

    ![](images/t4s2.png)

1. Create a clustered bar chart by selecting the **Clustered bar chart (1)** visual. From the **Data** pane, select **Country (2)** from the **Dim_Region** table and **Total Revenue (3)** from the **_Measures** table. Resize and position the chart beside the line chart.

    ![](images/t4s3.png)

1. Select the clustered bar chart. Select the **More options (1)** menu, choose **Sort by (2)**, select **Total Revenue (3)**, and then choose **Sort descending (4)**.

    ![](images/t4s5.png)

1. Create a slicer by selecting the **Slicer (1)** visual. From the **Data** pane, select **Country (2)** from the **Dim_Region** table. Resize and position the slicer below the charts.

    ![](images/t4s6.png)

1. Select the slicer **(1)**. In the **Visualizations** pane, select **Format visual (2)**. Expand **Slicer settings (3)**, change the **Style (4)** to **Dropdown (5)**.

    ![](images/t4s7.png)

1. Verify that the slicer is displayed as a **dropdown**.

    ![](images/t4s8.png)

1. Select the **dropdown arrow (1)** in the slicer and choose **India (2)**.

    ![](images/t4s9.png)

1. Verify that all visuals on the report are filtered to display data only for **India**.

    ![](images/t4s10.png)

1. Confirm that **India** is selected in the slicer.

    ![](images/t4s11.png)

1. Select the **line chart (1)**. In the **Visualizations** pane, select **Format visual (2)**, open the **General (3)** tab, expand **Title (4)**, and change the **Title text (5)** to **Revenue Trend (last 18 months)**.

    ![](images/t4s12.png)

1. Select the **bar chart (1)**. In the **Visualizations** pane, select **Format visual (2)**, open the **General (3)** tab, expand **Title (4)**, and change the **Title text (5)** to **Revenue by Region**.

    ![](images/t4s13.png)

## Task 5: Apply a theme

In this task you will apply and customize a report theme, add a dashboard title, and arrange the visuals into a polished, board-ready dashboard.

1. On the **View (1)** tab, scroll through the available themes **(2)** and select the **dark theme (3)** to apply it to the report.

    ![](images/t5s1.png)

1. After applying the theme, the report is displayed using the selected dark theme.

    ![](images/t5s2.png)

1. On the **View (1)** tab, scroll to the bottom of the Themes gallery **(2)** and select **Customize current theme (3)**.

    ![](images/t5s3.png)

1. In the **Customize theme** pane, select **Name and colors (1)**. Under **Theme colors**, change **Color 1 (2)** to a light green shade **(3)** and select **Apply (4)**.

    ![](images/t5s4.png)

1. On the **Insert (1)** tab, select **Text box (2)**. Enter **Sales Performance – Board View (3)** and set the font size to **24 (4)**.

    ![](images/t5s5.png)

1. Arrange the report visuals to create a dashboard layout. Position the title at the top and place the visuals as shown below.

    ![](images/t5s6.png)

## Summary

In this lab, you:

- Verified the sales dataset and imported the required CSV files into Power BI.
- Built a star schema data model with relationships, a date table, and hierarchies.
- Created DAX measures and KPI cards to analyze revenue, gross margin, and target attainment.
- Designed interactive report visuals, including charts and slicers, for sales analysis.
- Applied a custom theme and formatting to produce a professional, board-ready dashboard.

### You have Successfully completed this lab