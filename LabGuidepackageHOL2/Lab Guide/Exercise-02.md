# Exercise 2: Create a Visually Engaging Dashboard

### Estimated Duration: 60 Minutes

## 📘 Scenario

The Contoso Retail report is now live in the Power BI Service — but a report full of correct numbers can still fail its audience if it is hard to read or dull to look at. The executive team has asked for a **board-ready** experience: consistent branding, instantly readable performance indicators, richer visuals, and interactivity that lets one page do the work of several.

In this exercise, you will apply design polish so the dashboard is ready for the board: a layout grid and brand theme, conditional formatting, background and shape design elements, a custom AppSource visual, interactive tooltips, bookmarks and buttons, and finally an AI-generated narrative summary using Copilot.

## 🎯 Objectives

In this exercise, you will complete the following tasks:

- Task 1: Apply a layout grid and a theme (brand colours)
- Task 2: Add conditional formatting
- Task 3: Add background images, shapes, and subtle design enhancements
- Task 4: Add custom and third-party visuals from AppSource
- Task 5: Add tooltips, bookmarks, and buttons for interactivity
- Task 6: Generate a narrative summary with Copilot

## 🧩 Architecture Diagram

   ![](./Images/arch-exercise-02.png)

## Task 1: Apply a layout grid and a theme (brand colours)

In this task, you will align the visuals on the canvas using gridlines and snap-to-grid, and apply a consistent theme. Alignment and coordinated colours are the fastest way to make a report look professionally designed rather than assembled.

1. Return to **Power BI Desktop** and open the **StorePerformanceReport** if it is not already open.

   ![](./Images/e2s1.png)

1. Navigate to the report page that will be enhanced for executive presentation.

   ![](./Images/e2s1.png)

1. On the **View (1)** ribbon, select the checkboxes for **Gridlines ** and **Snap to grid (2)**.

   ![](./Images/e2s2.png)

   > **Note**: If prompted that snapping applies to objects as you move them, click **OK** to continue.

1. Reposition and resize the visuals so their edges align consistently with the grid on the report canvas.

1. Standardize the spacing between visuals — aim for even gaps on all sides so the page reads as an intentional layout.

   ![](./Images/L2E2T1S2.png)

   > **Tip**: You can select multiple visuals with **Ctrl+Click** and use **Format > Align** to align or distribute them precisely.

1. On the **View** ribbon, expand the **Themes** gallery.

   ![](./Images/e1s3.png)

1. Select an appropriate built-in theme that suits an executive audience — subtle colours with good contrast, such as **Executive** or **Accessible City Park**.

   ![](./Images/L2E2T1S4.png)

1. To match Contoso's brand style, expand the **Themes** gallery again and select **Customize current theme**.

1. In the **Customize theme** dialog, update the following:

   - **Name and colors (1)**: Adjust the first two theme colours to the brand palette (for example, `#0F6CBD` and `#212121`)
   - **Text (2)**: Set a consistent font family and sizes for titles, cards, and tab headers
   - Click **Apply (3)**

   ![](./Images/L2E2T1S5.png)

1. Review the report page — all visuals should now reflect the applied theme automatically.

1. Save the report by selecting **File > Save**.

## Task 2: Add conditional formatting

In this task, you will apply conditional formatting so important patterns and exceptions jump out immediately — green means performing, red means look here. This turns a wall of numbers into an instantly readable story.

1. On the report page, select a visual that supports conditional formatting, such as a **table**, **matrix**, or **bar chart**.

   ![](./Images/L2E2T2S1.png)

1. With the visual selected, in the **Visualizations** pane, locate the numeric field to be formatted (for example, **Quantity** or **Revenue**).

1. Right-click the field (or open its dropdown menu) and select **Conditional formatting (1)**, then choose **Background color (2)**.

   ![](./Images/L2E2T2S2.png)

   > **Note**: For chart visuals, conditional formatting is applied from **Format visual > Columns/Bars > Colors > fx** instead.

1. In the **Background color** dialog, configure the following:

   - **Format style (1)**: Rules
   - **What field should we base this on? (2)**: The selected measure or field
   - Add rules with business-friendly logic **(3)**:
     - If value is greater than or equal to the high threshold → **Green**
     - If value is between the medium thresholds → **Amber**
     - If value is less than the low threshold → **Red**
   - Click **OK (4)**

   ![](./Images/L2E2T2S3.png)

1. Review the updated visual and confirm the formatting highlights high, medium, and low performers as intended.

   ![](./Images/L2E2T2S4.png)

1. Repeat the process on a second element using a different formatting type — for example, add **Data bars** or **Icons** to a table column:

   - Open the field's **Conditional formatting** menu and select **Data bars (1)** or **Icons (2)**
   - Configure the scale or icon rules and click **OK (3)**

   ![](./Images/L2E2T2S5.png)

1. Save the report.

> **✅ Validation**: Confirm that at least one visual displays meaningful rule-based formatting that improves interpretation of business performance.

## Task 3: Add background images, shapes, and subtle design enhancements

In this task, you will add presentation elements — a background, section shapes, and a title banner — that improve structure and professional appearance without reducing usability. The goal is polish, not clutter: design should support the data, never compete with it.

1. Click an empty area of the report page you are polishing so no visual is selected.

1. In the **Visualizations** pane, select **Format page (paintbrush icon)** and expand **Canvas background**.

   ![](./Images/L2E2T3S1.png)

1. Configure the canvas background:

   - **Color (1)**: A very light neutral tint from your theme
   - Or click **Browse (2)** under Image to add the approved branded image from **C:\LabFiles\Images\contoso-background.png**
   - **Image fit (3)**: Fit
   - **Transparency (4)**: Adjust (for example, **85%**) so all visuals remain fully readable

   ![](./Images/L2E2T3S2.png)

   > **Note**: Also review the **Wallpaper** setting, which formats the area *outside* the report canvas — useful for widescreen presentation displays.

1. On the **Insert** ribbon, select **Shapes (1)** and choose **Rectangle (2)**.

   ![](./Images/L2E2T3S3.png)

1. Resize and position the rectangle across the top of the page to act as a **title banner**, and format it:

   - **Style > Fill (1)**: A primary brand colour
   - **Border (2)**: Off, or a subtle darker shade
   - Send it behind other elements if needed using **Format > Send backward**

   ![](./Images/L2E2T3S4.png)

1. Add one or two thin **Line** shapes to visually separate sections of the page (for example, KPIs at the top from detail charts below).

   ![](./Images/L2E2T3S5.png)

1. On the **Insert** ribbon, select **Text box** and enter the following page title:

   ```
   Executive Performance Dashboard
   ```

1. Format the title so it matches the selected report theme — set the font, size (for example, **24pt**), colour (white or a brand colour that contrasts with the banner), and **bold**, then position it on the title banner.

   ![](./Images/L2E2T3S6.png)

1. Select one of your main visuals and, in **Format visual > General > Effects**, review the subtle effect options:

   - **Background** — a soft white/neutral card behind the visual
   - **Visual border** — with **Rounded corners** (for example, `8 px`)
   - **Shadow** — a light outer shadow for gentle depth

   ![](./Images/L2E2T3S7.png)

1. Apply consistent effects across the visuals on the page, then step back and confirm the overall design remains clean, professional, and easy to read.

1. Save the report.

> **✅ Validation**: Confirm that the report page includes at least one design enhancement — such as a background, shape, or formatted title — while preserving readability and business focus.

## Task 4: Add custom and third-party visuals from AppSource

In this task, you will extend the native visualization library by importing a custom visual from AppSource and configuring it with your data. AppSource offers hundreds of Microsoft-certified and third-party visuals such as KPI indicators, gauges, and word clouds.

1. In Power BI Desktop, locate the **Visualizations** pane.

1. Click the **ellipses (…) (1)** at the end of the visual icons and select **Get more visuals (2)**.

   ![](./Images/L2E2T4S1.png)

1. In the **Power BI visuals** (AppSource) window, ensure the **AppSource** tab is selected, and in the search box **(1)**, search for a visual suitable for the reporting scenario, such as:

   ```
   Gauge
   ```

   > **Note**: Other good choices for this scenario include **KPI indicator**, **Bullet chart**, or **Word Cloud**. Prefer visuals with the blue **certified** badge, which have passed Microsoft's code review.

   ![](./Images/L2E2T4S2.png)

1. Select the visual from the results **(1)** and click **Add (2)**.

   ![](./Images/L2E2T4S3.png)

1. When the **Import successful** message appears, click **OK**, and confirm that the new visual's icon now appears in the **Visualizations** pane.

   ![](./Images/L2E2T4S4.png)

1. Click the new visual's icon to add it to the report canvas, and position it in your layout.

1. With the visual selected, populate it from the **Data** pane with the required fields — for example, drag **Quantity** (or a revenue measure) into the visual's value field well.

   ![](./Images/L2E2T4S5.png)

1. In **Format visual**, configure the visual's options — such as minimum/maximum values, target, colours, and labels — so it matches the report theme.

   ![](./Images/L2E2T4S6.png)

1. Evaluate whether the visual genuinely improves understanding of the report — if it doesn't add clarity, replace it or remove it.

1. Save the report.

> **✅ Validation**: Confirm that at least one AppSource visual has been added to the report and configured with data.

## Task 5: Add tooltips, bookmarks, and buttons for interactivity

In this task, you will add interactive components that improve navigation and provide additional context: a **report page tooltip** that reveals extra detail on hover, **bookmarks** that capture alternate view states, and a **button** that lets users switch between them.

### Part A: Create a tooltip page

1. At the bottom of the report canvas, click the **+ (New page)** icon to create a new report page, and rename it **Tooltip - Item Detail**.

   ![](./Images/L2E2T5S1.png)

1. With no visual selected, open **Format page** and configure:

   - **Page information > Allow use as tooltip (1)**: On
   - **Canvas settings > Type (2)**: Tooltip

   ![](./Images/L2E2T5S2.png)

   > **Note**: The Tooltip canvas size (320 × 240) keeps the pop-up compact. You can choose **Custom** for a slightly larger tooltip if needed.

1. Add one or two small supporting visuals to the tooltip page — for example, a compact card showing revenue and a mini column chart of quantity by month.

   ![](./Images/L2E2T5S3.png)

### Part B: Assign the tooltip page to a visual

1. Return to the main report page and select the visual that will use the custom tooltip (for example, the item sales bar chart).

1. In **Format visual > General**, expand **Tooltips** and configure:

   - **Type (1)**: Report page
   - **Page (2)**: Tooltip - Item Detail

   ![](./Images/L2E2T5S4.png)

1. Hover over a data point in the visual and confirm the custom tooltip page appears with context filtered to that item.

   ![](./Images/L2E2T5S5.png)

### Part C: Create bookmarks for alternate views

1. On the **View** ribbon, select the checkboxes to enable the **Bookmarks (1)** and **Selection (2)** panes.

   ![](./Images/L2E2T5S6.png)

1. Arrange the report page in its full, detailed state (all visuals visible), then in the **Bookmarks** pane click **Add (1)**. Open the new bookmark's **ellipses (…) (2)** menu, select **Rename (3)**, and name it:

   ```
   Detailed View
   ```

   ![](./Images/L2E2T5S7.png)

1. Change the page display state — for example, in the **Selection** pane, hide the detail table visual by clicking its **eye icon** — and then add another bookmark named:

   ```
   Summary View
   ```

   ![](./Images/L2E2T5S8.png)

   > **Note**: A bookmark captures the current state of the page, including filters, slicers, visibility, and sort order. Use the bookmark's ellipses menu to control which aspects (Data, Display, Current page) are captured.

### Part D: Add a button and wire it to a bookmark

1. On the **Insert** ribbon, select **Buttons (1)** and choose a button style such as **Bookmark** or **Blank (2)**.

   ![](./Images/L2E2T5S9.png)

1. Position the button near the top of the page and, in **Format button**, set the **Text** to `Switch View` (formatted to match the theme).

1. In **Format button**, toggle **Action (1)** to On and configure:

   - **Type (2)**: Bookmark
   - **Bookmark (3)**: Summary View

   ![](./Images/L2E2T5S10.png)

1. Test the interaction by holding **Ctrl** and clicking the button in Power BI Desktop — the page should switch to the Summary View state.

   ![](./Images/L2E2T5S11.png)

   > **Tip**: For a complete toggle experience, add a second button on the Summary View that navigates back to the **Detailed View** bookmark.

1. Save the report, then click **Publish** on the **Home** ribbon and republish to **Workspace-<inject key="DeploymentID" enableCopy="false"/>**, choosing **Replace** when prompted, so the enhanced version is live in the Power BI Service.

   ![](./Images/L2E2T5S12.png)

> **✅ Validation**: Confirm that the report includes at least one tooltip-enabled visual and one working button that triggers bookmark-based navigation or a saved view state.

## Task 6: Generate a narrative summary with Copilot

In this task, you will use **Copilot in Power BI**, where available, to generate a plain-language narrative summary of the report for an executive audience — and, just as importantly, learn to validate AI-generated output before it goes anywhere near a stakeholder.

1. Open the enhanced **StorePerformanceReport** in the **Power BI Service** (Copilot is also available in Power BI Desktop if enabled in your environment).

1. From the top ribbon of the report, click the **Copilot** button to open the Copilot pane.

   ![](./Images/L2E2T6S1.png)

   > **Note**: Copilot requires the workspace to be on a supported Fabric capacity (F2 or higher) or Power BI Premium, with Copilot enabled in the tenant settings by an administrator.

1. In the Copilot pane, review the suggested prompts, then select the report page that contains the key executive visuals.

1. In the prompt box, enter the following and press **Send**:

   ```
   Summarize the key business insights from this report page for an executive audience.
   ```

   ![](./Images/L2E2T6S2.png)

1. Review the generated narrative in the Copilot pane.

   ![](./Images/L2E2T6S3.png)

1. Refine the output by entering a follow-up prompt that focuses on specific business outcomes, for example:

   ```
   Focus the summary on the top three items by quantity sold and any notable exceptions.
   ```

1. **Validate** the generated summary against the visuals and measures in the report — check every number, ranking, and trend claim.

   > **Warning**: Always validate AI-generated output before sharing it with stakeholders. Copilot can misread a trend or misstate a figure; the analyst remains responsible for accuracy.

1. If your environment supports it, add the narrative to the report page — in Power BI Desktop, insert the **Narrative** visual with Copilot from the Visualizations pane — or copy the generated text and record it for later use in your executive briefing.

   ![](./Images/L2E2T6S4.png)

   > **Note**: If Copilot is not available in your environment, locate where the Copilot button would normally appear on the report ribbon, and document the specific dependency preventing its use (for example, capacity SKU, licensing, or a disabled tenant setting).

> **✅ Validation**: Confirm that a narrative summary was generated and reviewed for accuracy, or document the specific licensing or tenant dependency that prevents Copilot use.

> **Congratulations** on completing the exercise! Now, it's time to validate it. Here are the steps:
>
> - If you receive a success message, you have successfully completed the lab.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
> - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="00000000-0000-0000-0000-000000000002" />

## 📝 Summary

In this exercise, you have accomplished the following:

- Applied a layout grid and a consistent brand theme
- Added rule-based conditional formatting to highlight performance
- Enhanced the page with a background, shapes, a title banner, and subtle effects
- Imported and configured a custom visual from AppSource
- Built a report page tooltip, bookmarks, and a bookmark-triggered button
- Generated and validated a Copilot narrative summary, and republished the enhanced report

### You have successfully completed the lab. Click on **Next >>**.

![](./Images/gs-next.png.png)