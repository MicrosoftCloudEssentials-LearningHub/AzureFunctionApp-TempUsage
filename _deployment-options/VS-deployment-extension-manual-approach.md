# Function App manual deployment - Overview 

Costa Rica

[![GitHub](https://badgen.net/badge/icon/github?icon=github&label)](https://github.com)
[![GitHub](https://img.shields.io/badge/--181717?logo=github&logoColor=ffffff)](https://github.com/)
[brown9804](https://github.com/brown9804)

Last updated: 2025-10-01

----------

> [!NOTE]
> Here are a few examples that demonstrate the deployment process and the creation of E2E solution. Please feel free to use them as references if needed.
> - [Demo: Azure Implementation - PDF Layout Extraction with Azure AI Document Intelligence Supporting Multiple Document Versions with Visual Selection Cues (full-code approach)](https://github.com/MicrosoftCloudEssentials-LearningHub/PDFs-MultiLayout-VisualCue-AzureAI-Document-Processing)
> - [Demo: Automated PDF Invoice Processing with Open Framework (full-code approach)](https://github.com/MicrosoftCloudEssentials-LearningHub/PDFs-Invoice-Processing-Fapp-OpenFramework)
> - [Demo: PDF Layout Extraction with Doc Intelligence (full-code approach)](https://github.com/MicrosoftCloudEssentials-LearningHub/PDFs-Layouts-Processing-Fapp-DocIntelligence)
> - [Demo: Automated PDF Invoice Processing with Doc Intelligence (full-code approach)](https://github.com/MicrosoftCloudEssentials-LearningHub/PDFs-Invoice-Processing-Fapp-DocIntelligence)

## Function App Hosting Options 

> In the context of Azure Function Apps, a `hosting option refers to the plan you choose to run your function app`. This choice affects how your function app is scaled, the resources available to each function app instance, and the support for advanced functionalities like virtual network connectivity and container support.

> [!TIP]  
>
> - `Scale to Zero`: Indicates whether the service can automatically scale down to zero instances when idle.  
>   - **IDLE** stands for:  
>     - **I** – Inactive  
>     - **D** – During  
>     - **L** – Low  
>     - **E** – Engagement  
>   - In other words, when the application is not actively handling requests or events (it's in a low-activity or paused state).
> - `Scale Behavior`: Describes how the service scales (e.g., `event-driven`, `dedicated`, or `containerized`).  
> - `Virtual Networking`: Whether the service supports integration with virtual networks for secure communication.  
> - `Dedicated Compute & Reserved Cold Start`: Availability of always-on compute to avoid cold starts and ensure low latency.  
> - `Max Scale Out (Instances)`: Maximum number of instances the service can scale out to.  
> - `Example AI Use Cases`: Real-world scenarios where each plan excels.

<details>
<summary><strong>Flex Consumption</strong></summary>

| Feature | Description |
|--------|-------------|
| **Scale to Zero** | `Yes` |
| **Scale Behavior** | `Fast event-driven` |
| **Virtual Networking** | `Optional` |
| **Dedicated Compute & Reserved Cold Start** | `Optional (Always Ready)` |
| **Max Scale Out (Instances)** | `1000` |
| **Example AI Use Cases** | `Real-time data processing` for AI models, `high-traffic AI-powered APIs`, `event-driven AI microservices`. Ideal for fraud detection, real-time recommendations, NLP, and computer vision services. |

</details>

<details>
<summary><strong>Consumption</strong></summary>

| Feature | Description |
|--------|-------------|
| **Scale to Zero** | `Yes` |
| **Scale Behavior** | `Event-driven` |
| **Virtual Networking** | `Optional` |
| **Dedicated Compute & Reserved Cold Start** | `No` |
| **Max Scale Out (Instances)** | `200` |
| **Example AI Use Cases** | `Lightweight AI APIs`, `scheduled AI tasks`, `low-traffic AI event processing`. Great for sentiment analysis, simple image recognition, and batch ML tasks. |

</details>

<details>
<summary><strong>Functions Premium</strong></summary>

| Feature | Description |
|--------|-------------|
| **Scale to Zero** | `No` |
| **Scale Behavior** | `Event-driven with premium options` |
| **Virtual Networking** | `Yes` |
| **Dedicated Compute & Reserved Cold Start** | `Yes` |
| **Max Scale Out (Instances)** | `100` |
| **Example AI Use Cases** | `Enterprise AI applications`, `low-latency AI APIs`, `VNet integration`. Ideal for secure, high-performance AI services like customer support and analytics. |

</details>

<details>
<summary><strong>App Service</strong></summary>

| Feature | Description |
|--------|-------------|
| **Scale to Zero** | `No` |
| **Scale Behavior** | `Dedicated VMs` |
| **Virtual Networking** | `Yes` |
| **Dedicated Compute & Reserved Cold Start** | `Yes` |
| **Max Scale Out (Instances)** | `Varies` |
| **Example AI Use Cases** | `AI-powered web applications`, `dedicated resources`. Great for chatbots, personalized content, and intensive AI inference. |

</details>

<details>
<summary><strong>Container Apps Env.</strong></summary>

| Feature | Description |
|--------|-------------|
| **Scale to Zero** | `No` |
| **Scale Behavior** | `Containerized microservices environment` |
| **Virtual Networking** | `Yes` |
| **Dedicated Compute & Reserved Cold Start** | `Yes` |
| **Max Scale Out (Instances)** | `Varies` |
| **Example AI Use Cases** | `AI microservices architecture`, `containerized AI workloads`, `complex AI workflows`. Ideal for orchestrating AI services like image processing, text analysis, and real-time analytics. |

</details>

## Function App: Configure/Validate the Environment variables

> [!NOTE]
> This example is using system-assigned managed identity to assign RBACs (Role-based Access Control).

- Under `Settings`, go to `Environment variables`. And `+ Add` the following variables:

  - `COSMOS_DB_ENDPOINT`: Your Cosmos DB account endpoint 🡢 `Review the existence of this, if not create it`
  - `COSMOS_DB_KEY`: Your Cosmos DB account key 🡢 `Review the existence of this, if not create it`
  - `COSMOS_DB_CONNECTION_STRING`: Your Cosmos DB connection string 🡢 `Review the existence of this, if not create it`
  - `invoicecontosostorage_STORAGE`: Your Storage Account connection string 🡢 `Review the existence of this, if not create it`
  - `FORM_RECOGNIZER_ENDPOINT`: For example: `https://<your-form-recognizer-endpoint>.cognitiveservices.azure.com/` 🡢 `Review the existence of this, if not create it`
  - `FORM_RECOGNIZER_KEY`: Your Documment Intelligence Key (Form Recognizer). 🡢
  - `FUNCTIONS_EXTENSION_VERSION`: `~4` 🡢 `Review the existence of this, if not create it`
  - `WEBSITE_RUN_FROM_PACKAGE`: `1` 🡢 `Review the existence of this, if not create it`
  - `FUNCTIONS_WORKER_RUNTIME`: `python` 🡢 `Review the existence of this, if not create it`
  - `FUNCTIONS_NODE_BLOCK_ON_ENTRY_POINT_ERROR`: `true` (This setting ensures that all entry point errors are visible in your application insights logs). 🡢 `Review the existence of this, if not create it`

      <img width="550" alt="image" src="https://github.com/user-attachments/assets/31d813e7-38ba-46ff-9e4b-d091ae02706a">

      <img width="550" alt="image" src="https://github.com/user-attachments/assets/45313857-b337-4231-9184-d2bb46e19267">

      <img width="550" alt="image" src="https://github.com/user-attachments/assets/074d2fa5-c64d-43bd-8ed7-af6da46d86a2">

      <img width="550" alt="image" src="https://github.com/user-attachments/assets/ec5d60f3-5136-489d-8796-474b7250865d">

  - Click on `Apply` to save your configuration.
    
      <img width="550" alt="image" src="https://github.com/user-attachments/assets/437b44bb-7735-4d17-ae49-e211eca64887">

## Function App: Develop the logic

- You need to install [VSCode](https://code.visualstudio.com/download)
- Install python from Microsoft store:
    
     <img width="550" alt="image" src="https://github.com/user-attachments/assets/30f00c27-da0d-400f-9b98-817fd3e03b1c">

- Open VSCode, and install some extensions: `python`, and `Azure Tools`.

     <img width="550" alt="image" src="https://github.com/user-attachments/assets/715449d3-1a36-4764-9b07-99421fb1c834">

     <img width="550" alt="image" src="https://github.com/user-attachments/assets/854aa665-dc2f-4cbf-bae2-2dc0a8ef6e46">

- Click on the `Azure` icon, and `sign in` into your account. Allow the extension `Azure Resources` to sign in using Microsoft, it will open a browser window. After doing so, you will be able to see your subscription and resources.

    <img width="550" alt="image" src="https://github.com/user-attachments/assets/4824ca1c-4959-4242-95af-ad7273c5530d">

- Under Workspace, click on `Create Function Project`, and choose a path in your local computer to develop your function.

    <img width="550" alt="image" src="https://github.com/user-attachments/assets/2c42d19e-be8b-48ef-a7e4-8a39989cea5a">

- Choose the language, in this case is `python`:

   <img width="550" alt="image" src="https://github.com/user-attachments/assets/2fb19a1e-bb2d-47e5-a56e-8dc8a708647a">

- Select the model version, for this example let's use `v2`:
  
   <img width="550" alt="image" src="https://github.com/user-attachments/assets/fd46ee93-d788-463d-8b28-dbf2487e9a7f">

- For the python interpreter, let's use the one installed via `Microsoft Store`:

   <img width="550" alt="image" src="https://github.com/user-attachments/assets/3605c959-fc59-461f-9e8d-01a6a92004a8">

- Choose a template (e.g., **Blob trigger**) and configure it to trigger on new PDF uploads in your Blob container.

   <img width="550" alt="image" src="https://github.com/user-attachments/assets/0a4ed541-a693-485c-b6ca-7d5fb55a61d2">

- Provide a function name, like `BlobTriggerContosoPDFInvoicesDocIntelligence`:

   <img width="550" alt="image" src="https://github.com/user-attachments/assets/263cef5c-4460-46cb-8899-fb609b191d81">

- Next, it will prompt you for the path of the blob container where you expect the function to be triggered after a file is uploaded. In this case is `pdfinvoices` as was previously created.

  <img width="550" alt="image" src="https://github.com/user-attachments/assets/7005dc44-ffe2-442b-8373-554b229b3042">

- Click on `Create new local app settings`, and then choose your subscription.

  <img width="550" alt="image" src="https://github.com/user-attachments/assets/07c211d6-eda0-442b-b428-cdaed2bf12ac">

- Choose `Azure Storage Account for remote storage`, and select one. I'll be using the `invoicecontosostorage`. 

  <img width="550" alt="image" src="https://github.com/user-attachments/assets/3b5865fc-3e84-4582-8f06-cb5675d393f0">

- Then click on `Open in the current window`. You will see something like this:

  <img width="550" alt="image" src="https://github.com/user-attachments/assets/f30e8e10-0c37-4efc-8158-c83faf22a7d8">

- Now we need to update the function code to extract data from PDFs and store it in Cosmos DB, use this an example:

    > 1. **PDF Upload**: A PDF file is uploaded to the Azure Blob Storage container (`pdfinvoices`).
    > 2. **Trigger Azure Function**: The upload triggers the Azure Function `BlobTriggerContosoPDFLayoutsDocIntelligence`.
    > 3. **Initialize Clients**: Sets up connections to Azure Document Intelligence and Cosmos DB.  
    >    - Initializes the `DocumentAnalysisClient` using the `FORM_RECOGNIZER_ENDPOINT` and `FORM_RECOGNIZER_KEY` environment variables.  
    >    - Initializes the `CosmosClient` using Azure Active Directory (AAD) via `DefaultAzureCredential`.
    > 4. **Read PDF from Blob Storage**: Reads the PDF content from the blob into a byte stream.
    > 5. **Analyze PDF**: Uses Azure Document Intelligence to analyze the layout of the PDF.  
    >    - Calls `begin_analyze_document` with the `prebuilt-layout` model.  
    >    - Waits for the analysis to complete and retrieves the layout result.
    > 6. **Extract Layout Data**: Parses and structures the layout data from the analysis result.  
    >    - Extracts lines, tables, and selection marks from each page.  
    >    - Logs styles (e.g., handwritten content) and organizes data into a structured dictionary.
    > 7. **Save Data to Cosmos DB**: Saves the structured layout data to Cosmos DB.  
    >    - Ensures the database (`ContosoDBDocIntellig`) and container (`Layouts`) exist or creates them.  
    >    - Inserts or updates the layout data using `upsert_item`.
    > 8. **Logging (Process and Errors)**: Logs each step of the process, including success messages and detailed error handling for debugging and monitoring.

  - Update the function_app.py, for example see the code used in each demo:
     - [Demo: Azure Implementation - PDF Layout Extraction with Azure AI Document Intelligence Supporting Multiple Document Versions with Visual Selection Cues (full-code approach)](https://github.com/MicrosoftCloudEssentials-LearningHub/PDFs-MultiLayout-VisualCue-AzureAI-Document-Processing)
     - [Demo: Automated PDF Invoice Processing with Open Framework (full-code approach)](https://github.com/MicrosoftCloudEssentials-LearningHub/PDFs-Invoice-Processing-Fapp-OpenFramework)
     - [Demo: PDF Layout Extraction with Doc Intelligence (full-code approach)](https://github.com/MicrosoftCloudEssentials-LearningHub/PDFs-Layouts-Processing-Fapp-DocIntelligence)
     - [Demo: Automated PDF Invoice Processing with Doc Intelligence (full-code approach)](https://github.com/MicrosoftCloudEssentials-LearningHub/PDFs-Invoice-Processing-Fapp-DocIntelligence)

      | Template Blob Trigger | Function Code updated |
      | --- | --- |
      |   <img width="550" alt="image" src="https://github.com/user-attachments/assets/07a7b285-eed2-4b42-bb1f-e41e8eafd273"> |  <img width="550" alt="image" src="https://github.com/user-attachments/assets/d364591b-817e-4f36-8c50-7de187c32a1e">|

  - Now, let's update the `requirements.txt`, see the code used in each demo:
     - [Demo: Azure Implementation - PDF Layout Extraction with Azure AI Document Intelligence Supporting Multiple Document Versions with Visual Selection Cues (full-code approach)](https://github.com/MicrosoftCloudEssentials-LearningHub/PDFs-MultiLayout-VisualCue-AzureAI-Document-Processing)
     - [Demo: Automated PDF Invoice Processing with Open Framework (full-code approach)](https://github.com/MicrosoftCloudEssentials-LearningHub/PDFs-Invoice-Processing-Fapp-OpenFramework)
     - [Demo: PDF Layout Extraction with Doc Intelligence (full-code approach)](https://github.com/MicrosoftCloudEssentials-LearningHub/PDFs-Layouts-Processing-Fapp-DocIntelligence)
     - [Demo: Automated PDF Invoice Processing with Doc Intelligence (full-code approach)](https://github.com/MicrosoftCloudEssentials-LearningHub/PDFs-Invoice-Processing-Fapp-DocIntelligence)

    | Template `requirements.txt` | Updated `requirements.txt` |
    | --- | --- |
    | <img width="550" alt="image" src="https://github.com/user-attachments/assets/239516e0-a4b7-4e38-8c2b-9be12ebb00de"> | <img width="550" alt="image" src="https://github.com/user-attachments/assets/91bd6bd8-ec21-4e1a-ae86-df577d37bcbb">| 

  - Since this function has already been tested, you can deploy your code to the function app in your subscription. If you want to test, you can use run your function locally for testing.
    - Click on the `Azure` icon.
    - Under `workspace`, click on the `Function App` icon.
    - Click on `Deploy to Azure`.

         <img width="550" alt="image" src="https://github.com/user-attachments/assets/12405c04-fa43-4f09-817d-f6879fbff035">

    - Select your `subscription`, your `function app`, and accept the prompt to overwrite:

         <img width="550" alt="image" src="https://github.com/user-attachments/assets/b69212a5-ab79-45e2-8344-73198b231d07">

    - After completing, you see the status in your terminal:

         <img width="550" alt="image" src="https://github.com/user-attachments/assets/6214e246-5beb-4ae4-a54b-9101cac3e241">

         <img width="550" alt="image" src="https://github.com/user-attachments/assets/78aab42c-af43-43aa-a4c0-545f4445755b">

> [!IMPORTANT]
> If you need a hand with the code, just check out some of the examples, they’ve got extra information.
> - [Demo: Azure Implementation - PDF Layout Extraction with Azure AI Document Intelligence Supporting Multiple Document Versions with Visual Selection Cues (full-code approach)](https://github.com/MicrosoftCloudEssentials-LearningHub/PDFs-MultiLayout-VisualCue-AzureAI-Document-Processing)
> - [Demo: Automated PDF Invoice Processing with Open Framework (full-code approach)](https://github.com/MicrosoftCloudEssentials-LearningHub/PDFs-Invoice-Processing-Fapp-OpenFramework)
> - [Demo: PDF Layout Extraction with Doc Intelligence (full-code approach)](https://github.com/MicrosoftCloudEssentials-LearningHub/PDFs-Layouts-Processing-Fapp-DocIntelligence)
> - [Demo: Automated PDF Invoice Processing with Doc Intelligence (full-code approach)](https://github.com/MicrosoftCloudEssentials-LearningHub/PDFs-Invoice-Processing-Fapp-DocIntelligence)
