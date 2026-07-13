# Challenge 2: Stretch goals and submission

### Estimated Duration: 120 Minutes

## Overview

In this exercise, you will enhance the Power BI dashboard by implementing Row-Level Security (RLS), generating AI-powered insights with Copilot, and adding a custom visual for target analysis. You will then publish the report to a Fabric workspace, export it as a PDF, and perform a comprehensive validation to ensure the dashboard is secure, accurate, and ready for business stakeholders.

## Objectives

In this exercise you will:

- Task 1: Apply Row-Level Security by region
- Task 2: Add a Copilot narrative
- Task 3: Add a custom visual
- Task 4: Submit your dashboard (publish to a shared workspace or submit screenshots)
- Task 5: Self-check against the evaluation rubric (Read-only)

## Task 1: Apply Row-Level Security by Region

1. Open **Modeling** > **Manage roles**.

2. Create region-based security roles for each business region.

3. Apply a DAX filter on the **Dim_Region** table to restrict data by **Region**.

4. Save all the security roles.

5. Use **View as** to test the **RLS - North America** role and verify that only North America data is visible.

6. Repeat the validation for another role (for example, **RLS - Europe**) to confirm the security rules work correctly.

## Task 2: Add a Copilot Narrative

1. Sign in to **Power BI Copilot** using the lab-provided credentials.

2. Select or create a **Fabric workspace** if required.

3. Open the **Copilot** pane and generate a summary of regional revenue performance using an appropriate prompt.

4. Add the generated narrative to the report as a **Text box**.

5. Review the narrative to ensure it accurately reflects the report data.

## Task 3: Add a Custom Visual

1. Create a new DAX measure named **Total Target**.

2. Import the **Bullet Chart by OKVIZ** visual from **AppSource**.

3. Add the Bullet Chart to the report canvas.

4. Configure the visual using **Total Revenue** and **Total Target**.

5. Update the visual formatting to match the report theme.

6. Rename the visual title to **Revenue vs. Target**.

## Task 4: Submit Your Dashboard

1. Save the completed report as **Board-Ready-Dashboard.pbix**.

2. Publish the report to the assigned **Fabric workspace**.

3. Verify that both the report and its semantic model are available in the workspace.

4. Export the report as a **PDF**.

5. Confirm that the exported PDF contains the completed dashboard.

## Task 5: Self-Check Against the Evaluation Rubric

1. Verify the semantic model, relationships, hidden columns, and date table configuration.

2. Review all KPI cards, charts, and slicers to ensure they display accurate data and respond correctly to filters.

3. Validate at least two **Row-Level Security (RLS)** roles using **View as**.

4. Review the Copilot narrative and custom visual to ensure they accurately represent the report.

5. Perform a final formatting review and confirm the dashboard is presentation-ready before submission.

## Summary

In this lab, you:

- Configured and validated Row-Level Security (RLS) to restrict data access by region.
- Used Copilot to generate an AI-powered narrative summarizing sales performance.
- Added and customized a Bullet Chart to compare actual revenue against target revenue.
- Published the completed report to a Fabric workspace and exported it as a PDF.
- Performed a final quality review to validate the data model, visuals, interactions, security, and overall report readiness.

### You have Successfully completed this lab