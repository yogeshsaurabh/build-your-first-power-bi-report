# Exercise 01: Get started and prepare your retail data

### Estimated Duration: 1.5 Hours

## Scenario

You are a new analyst for a fictional retail chain. The company has provided four CSV files with sales transactions, store details, product details, and calendar dates. In this exercise, you will use Power BI Desktop to import those files, clean and shape them in Power Query, and create the relationships needed for a store performance report.

## Overview

In this exercise, you will open the prepared lab workspace, launch Power BI Desktop, tour the main authoring areas, connect to four local CSV files, apply beginner-friendly Power Query transformations, load the data into the model, verify table relationships, and refresh the model.

The local working folder for this lab is:

`C:\LabFiles\PowerBI-Retail`

The source files are:

- `C:\LabFiles\PowerBI-Retail\Sales.csv`
- `C:\LabFiles\PowerBI-Retail\Stores.csv`
- `C:\LabFiles\PowerBI-Retail\Products.csv`
- `C:\LabFiles\PowerBI-Retail\Dates.csv`

Your lab deployment is **Power BI Retail Lab - <inject key="DeploymentID" enableCopy="false"></inject>**.

## Objectives

- Task 1: Verify the lab workspace and launch Power BI Desktop
- Task 2: Tour the Power BI Desktop interface
- Task 3: Connect to the four retail CSV files
- Task 4: Shape and clean the data in Power Query
- Task 5: Load the data and verify relationships
- Task 6: Refresh and save your starter Power BI file

## Task 1: Verify the lab workspace and launch Power BI Desktop

In this task, you will confirm the lab files are present and open Power BI Desktop on the lab VM.

1. Sign in to the lab VM using the connection experience provided by CloudLabs.

2. If you need to sign in to the Azure portal for lab context, browse to <https://portal.azure.com> and use the following credentials:

   - Username: `<inject key="AzureAdUserEmail"></inject>`
   - Password: `<inject key="AzureAdUserPassword"></inject>`

   > [!Note]
   > The Power BI work in this lab is completed in Power BI Desktop on the VM. Publishing to the Power BI service is optional and is not required for this exercise.

3. On the Windows desktop, open **File Explorer**.

4. Go to `C:\LabFiles\PowerBI-Retail`.

5. Confirm that the following items exist:

   - `Sales.csv`
   - `Stores.csv`
   - `Products.csv`
   - `Dates.csv`
   - `Evidence` folder

6. From the Windows **Start** menu, search for **Power BI Desktop**, and then open it.

7. If a sign-in window or welcome screen appears, close it or choose the option to continue without signing in.

   > [!Tip]
   > Power BI Desktop can create and save a local `.pbix` report without a Power BI service sign-in.

8. Wait until the blank Power BI Desktop report canvas opens.

## Task 2: Tour the Power BI Desktop interface

In this task, you will identify the main Power BI Desktop areas that you will use throughout the lab.

1. In Power BI Desktop, look at the left side of the window. You should see three primary view icons:

   - **Report view**: Used to build report pages and visuals.
   - **Table view**: Used to inspect loaded table data and create calculations.
   - **Model view**: Used to view and manage relationships between tables.

2. Select **Report view**.

   This is where you will build the store performance dashboard in the next exercise.

3. Select **Table view**.

   You might not see much data yet because the CSV files have not been loaded.

4. Select **Model view**.

   This view will later show the `Sales`, `Stores`, `Products`, and `Dates` tables and the relationship lines between them.

5. Return to **Report view**.

6. On the right side of Power BI Desktop, identify these panes:

   - **Data** or **Fields** pane: Lists loaded tables and columns.
   - **Visualizations** pane: Lets you choose chart types and configure fields.
   - **Filters** pane: Lets you filter visuals, pages, or the full report.

7. On the top ribbon, select the **Home** tab and locate these buttons:

   - **Get data**
   - **Transform data**
   - **Refresh**
   - **Publish**

   > [!Note]
   > You will use **Get data** to connect to CSV files, **Transform data** to open Power Query Editor, and **Refresh** to rerun the import after your queries are configured.

## Task 3: Connect to the four retail CSV files

In this task, you will import the four CSV files into Power BI Desktop. You will use **Transform Data** instead of loading immediately so you can clean the data first.

1. In Power BI Desktop, on the **Home** ribbon, select **Get data** > **Text/CSV**.

2. Browse to `C:\LabFiles\PowerBI-Retail`.

3. Select `Sales.csv`, and then select **Open**.

4. In the preview window, review the detected delimiter, column headers, and sample rows.

5. Select **Transform Data**.

   Power Query Editor opens and displays the `Sales` query.

6. In Power Query Editor, in the **Home** ribbon, select **New Source** > **Text/CSV**.

7. Browse to `C:\LabFiles\PowerBI-Retail`, select `Stores.csv`, and then select **Open**.

8. In the preview window, select **OK** or **Transform Data**.

9. Repeat the same process to add the remaining two files:

   - `Products.csv`
   - `Dates.csv`

10. In the left **Queries** pane, confirm that you now have four queries:

    - `Sales`
    - `Stores`
    - `Products`
    - `Dates`

11. If any query name includes the file extension, such as `Sales.csv`, right-click the query name, select **Rename**, and rename it to the clean table name, such as `Sales`.

   > [!Tip]
   > Clean table names make DAX formulas and report fields easier to read later.

## Task 4: Shape and clean the data in Power Query

In this task, you will apply moderate Power Query shaping steps to prepare the data for reporting. Power Query records each transformation as an **Applied Step**, so you can review or remove steps later if needed.

### Clean the Sales query

1. In the left **Queries** pane, select `Sales`.

2. Confirm that the first row is used as column headers. If the headers appear as data values, select **Home** > **Use First Row as Headers**.

3. Review the column names. If needed, rename columns so they are easy to understand. Use names similar to the following:

   - `SaleID`
   - `StoreID`
   - `ProductID`
   - `Date`
   - `Quantity`
   - `UnitPrice`
   - `SalesAmount`

   To rename a column, double-click the column header, enter the new name, and press **Enter**.

4. Set data types for the key columns:

   | Column | Data type |
   |---|---|
   | `SaleID` | Text or Whole Number |
   | `StoreID` | Text or Whole Number |
   | `ProductID` | Text or Whole Number |
   | `Date` | Date |
   | `Quantity` | Whole Number |
   | `UnitPrice` | Fixed Decimal Number or Decimal Number |
   | `SalesAmount` | Fixed Decimal Number or Decimal Number |

   To change a data type, select the data type icon to the left of the column name, and then choose the correct type.

5. Remove blank rows:

   - Select **Home** > **Remove Rows** > **Remove Blank Rows**.

6. Check for obvious errors:

   - Select the drop-down menu on numeric columns such as `Quantity`, `UnitPrice`, or `SalesAmount`.
   - If you see an **Errors** option, review the affected rows.
   - For this beginner lab, remove error rows by selecting the column and then selecting **Home** > **Remove Rows** > **Remove Errors**.

7. If your `Sales` file does not already contain `SalesAmount`, create it:

   - Select **Add Column** > **Custom Column**.
   - In **New column name**, enter `SalesAmount`.
   - In **Custom column formula**, enter:

     ```powerquery
     [Quantity] * [UnitPrice]
     ```

   - Select **OK**.
   - Set the new `SalesAmount` column data type to **Fixed Decimal Number** or **Decimal Number**.

8. If the `Date` column shows a time component, change its data type to **Date** so it aligns cleanly with the `Dates` table.

9. In the **Query Settings** pane, review the **Applied Steps** list. You should see steps such as **Promoted Headers**, **Changed Type**, **Removed Blank Rows**, and possibly **Added Custom**.

### Clean the Stores query

1. In the left **Queries** pane, select `Stores`.

2. Rename columns if needed so they use clear names such as:

   - `StoreID`
   - `StoreName`
   - `Region`
   - `City`
   - `State`
   - `Country`
   - `Latitude`
   - `Longitude`

3. Set data types:

   | Column | Data type |
   |---|---|
   | `StoreID` | Text or Whole Number |
   | `StoreName` | Text |
   | `Region` | Text |
   | `City` | Text |
   | `State` | Text |
   | `Country` | Text |
   | `Latitude` | Decimal Number |
   | `Longitude` | Decimal Number |

4. Standardize region values:

   - Select the `Region` column.
   - Select **Transform** > **Replace Values**.
   - Replace any inconsistent abbreviations or spelling variants. For example:
     - Replace `N.` with `North` if it exists.
     - Replace `S.` with `South` if it exists.
     - Replace `E.` with `East` if it exists.
     - Replace `W.` with `West` if it exists.

   > [!Note]
   > Your generated dataset might not contain every inconsistent value listed above. Apply replacements only when you see a matching value in the column filter list or data preview.

5. If a store location column combines city and state in one field, split it:

   - Select the combined location column.
   - Select **Transform** > **Split Column** > **By Delimiter**.
   - Choose the delimiter shown in your data, such as comma `,` or hyphen `-`.
   - Rename the resulting columns to `City` and `State`.

### Clean the Products query

1. In the left **Queries** pane, select `Products`.

2. Rename columns if needed so they use clear names such as:

   - `ProductID`
   - `ProductName`
   - `Category`
   - `Subcategory`
   - `UnitPrice`

3. Set data types:

   | Column | Data type |
   |---|---|
   | `ProductID` | Text or Whole Number |
   | `ProductName` | Text |
   | `Category` | Text |
   | `Subcategory` | Text |
   | `UnitPrice` | Fixed Decimal Number or Decimal Number |

4. Standardize product category values:

   - Select the `Category` column.
   - Open the filter drop-down to inspect unique values.
   - If you see inconsistent values, use **Transform** > **Replace Values** to make them consistent. For example, replace `Elec.` with `Electronics` if it appears.

5. If `ProductName` and `Category` need a helper label, create a merged display column:

   - Select `Category`.
   - Hold **Ctrl** and select `ProductName`.
   - Select **Add Column** > **Merge Columns**.
   - Use ` - ` as the separator.
   - Name the new column `ProductDisplayName`.
   - Select **OK**.

   > [!Tip]
   > `ProductDisplayName` is optional, but it can make tables or tooltips easier to read in the report.

### Clean the Dates query

1. In the left **Queries** pane, select `Dates`.

2. Rename columns if needed so they use clear names such as:

   - `Date`
   - `Year`
   - `Quarter`
   - `Month`
   - `MonthName`

3. Set data types:

   | Column | Data type |
   |---|---|
   | `Date` | Date |
   | `Year` | Whole Number |
   | `Quarter` | Text or Whole Number |
   | `Month` | Whole Number |
   | `MonthName` | Text |

4. If the table does not include `MonthName`, add it:

   - Select the `Date` column.
   - Select **Add Column** > **Date** > **Month** > **Name of Month**.
   - Rename the new column to `MonthName` if needed.

5. If the table does not include `Year`, add it:

   - Select the `Date` column.
   - Select **Add Column** > **Date** > **Year** > **Year**.
   - Rename the new column to `Year` if needed.

6. Confirm that the `Date` column in this query has the same data type as the `Date` column in the `Sales` query.

## Task 5: Load the data and verify relationships

In this task, you will apply your Power Query changes, load the tables into Power BI Desktop, and confirm that the model relationships are correct.

1. In Power Query Editor, select **Home** > **Close & Apply**.

2. Wait for Power BI Desktop to apply the query changes and load the four tables.

3. In Power BI Desktop, select **Model view** from the left side of the window.

4. Check whether Power BI Desktop automatically created relationships between the tables.

5. You should have these relationships:

   | From table | From column | To table | To column | Cardinality goal |
   |---|---|---|---|---|
   | `Stores` | `StoreID` | `Sales` | `StoreID` | One-to-many (`1:*`) |
   | `Products` | `ProductID` | `Sales` | `ProductID` | One-to-many (`1:*`) |
   | `Dates` | `Date` | `Sales` | `Date` | One-to-many (`1:*`) |

6. If a relationship already exists, hover over the relationship line to inspect the connected columns.

7. If a relationship is missing, create it manually:

   - On the ribbon, select **Modeling** > **Manage relationships**.
   - Select **New**.
   - Choose the first table and column, such as `Stores[StoreID]`.
   - Choose the second table and column, such as `Sales[StoreID]`.
   - Confirm the **Cardinality** is **One to many (1:*)** or **Many to one (*:1)** depending on the order of the selected tables.
   - Set **Cross filter direction** to **Single**.
   - Confirm **Make this relationship active** is selected.
   - Select **OK**.

8. Repeat the previous step for the `Products` to `Sales` and `Dates` to `Sales` relationships if they are missing.

9. Select **Close** to exit **Manage relationships**.

10. In **Model view**, arrange the tables so `Sales` is in the center and the lookup tables are around it:

    - `Stores`
    - `Products`
    - `Dates`

    > [!Tip]
    > This layout makes it easier to see that `Sales` is the transaction table and the other tables provide descriptive details for stores, products, and dates.

11. Select **Table view** and open each table briefly to confirm rows are loaded.

12. Return to **Report view**.

## Task 6: Refresh and save your starter Power BI file

In this task, you will refresh the model and save a starter `.pbix` file that you will continue using in the next exercises.

1. On the **Home** ribbon, select **Refresh**.

2. Wait for the refresh to complete.

3. If a refresh error appears, read the message carefully. Common beginner issues include:

   - A column was renamed differently than expected.
   - A data type was applied to a value that cannot be converted.
   - A relationship column has mismatched data types, such as text in one table and whole number in another.

4. If you need to fix an issue, select **Transform data**, update the affected query, and then select **Close & Apply** again.

5. When refresh succeeds, select **File** > **Save As**.

6. Save the file as:

   `C:\LabFiles\PowerBI-Retail\Evidence\StorePerformanceReport.pbix`

   > [!Important]
   > Use the exact file name and folder path above. Later validations check for this file in the `Evidence` folder.

7. Keep Power BI Desktop open. You will build the report visuals in the next exercise.

## Summary

In this exercise, you verified the lab workspace, opened Power BI Desktop, toured the main interface, connected to four local CSV files, cleaned and shaped data in Power Query, loaded the tables into the model, created or verified relationships, refreshed the model, and saved the starter `StorePerformanceReport.pbix` file. You now have a clean retail model ready for dashboard building.
