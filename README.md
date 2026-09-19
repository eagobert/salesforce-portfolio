# Salesforce Portfolio Source

An Experience Cloud portfolio experiment built with Salesforce DX, Aura components, Apex, and Experience Bundle metadata.

## What this repository shows

- Custom Aura theme layouts for portfolio home, about, projects, and contact views
- Aura navigation and content components styled with CSS and Salesforce Lightning Design System
- A contact page that uses Lightning Data Service to prepare and save a Lead record
- An Apex controller and Aura components for an assigned-task interface
- Experience Cloud routes, views, themes, content assets, and configuration captured as source metadata

The code demonstrates how an Experience Cloud site can combine reusable Aura components, page layouts, and Salesforce data. It is a source snapshot of portfolio work, not a hosted demo.

## Explore the implementation

| Location | What to look for |
| --- | --- |
| `force-app/main/default/aura/portfolioHomeLayout/` | Home theme layout |
| `force-app/main/default/aura/portfolioContactLayout/` | Lead contact form and client-side handling |
| `force-app/main/default/aura/portfolioNavigation/` | Site navigation component |
| `force-app/main/default/classes/AssignedTasksManager.cls` | Apex methods for task data; portions of the original implementation are commented out |
| `force-app/main/default/experiences/` | Experience Bundle routes, views, theme, and site configuration |
| `manifest/package.xml` | Historical metadata selection |

## Salesforce context

This project uses Salesforce DX source format and targets an Experience Cloud site. A Salesforce org with Experience Cloud enabled and the appropriate permissions would be required to explore the site in an org. The `sfdx-project.json` file records source API version 64.0 and an org-specific login URL; replace that login target with your own org when experimenting.

## Current status and limits

The original README contains unfinished placeholders. This repository has not been verified as a one-command deployment. The historical `manifest/package.xml` names some metadata that is not present in the current source tree, and the assigned-task implementation includes commented-out Apex. Review the metadata and deploy only the components you intend to use in a non-production org. There is no published demo link or verified test run associated with this README.

## What it demonstrates

Experience Cloud source structure, Aura theme composition, Lightning Data Service, Apex-to-component integration, and CSS/SLDS styling. See the code for the exact implemented behavior; no production outcomes are claimed here.
