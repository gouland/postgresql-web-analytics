
const API_URL = "/api/work-orders";

const tableBody = document.getElementById("workOrdersTable");

const searchInput = document.getElementById("searchInput");

const statusFilter = document.getElementById("statusFilter");

const refreshButton = document.getElementById("refreshButton");

const connectionStatus = document.getElementById("connectionStatus");

let allOrders = [];

const currencyFormatter = new Intl.NumberFormat("en-KE", {
    style: "currency",
    currency: "KES",
    maximumFractionDigits: 0
});


// 1. Retrieve records from Flask API

async function loadWorkOrders() {

    connectionStatus.textContent = "Loading...";
    
    try {

        const response = await fetch(API_URL, {
            cache: "no-store"
        });

        if (!response.ok) {
            throw new Error("API returned HTTP " + response.status);
        }

        const result = await response.json();

        if (result.status !== "success") {
            throw new Error(result.message || "Unable to retrieve records");
        }

        allOrders = result.data;

        connectionStatus.textContent = "Database Connected";
        connectionStatus.classList.remove("error");

        updateSummary(allOrders);

        renderTable(allOrders);

        document.getElementById("lastUpdated").textContent =
            "Last refreshed: " + new Date().toLocaleTimeString();

    }

    catch (error) {

        console.error("Dashboard error:", error);

        connectionStatus.textContent = "Connection Error";
        connectionStatus.classList.add("error");

        tableBody.replaceChildren();

        const row = document.createElement("tr");
        const cell = document.createElement("td");

        cell.colSpan = 8;
        cell.className = "error-row";
        cell.textContent = "Unable to load work orders. Check the server and database.";

        row.appendChild(cell);
        tableBody.appendChild(row);
    }
}


// 2. Update KPI cards

function updateSummary(orders) {

    const completed = orders.filter(
        order => order.status === "Completed"
    );

    const pending = orders.filter(
        order => order.status === "Pending"
    );

    const totalValue = orders.reduce(
        (sum, order) => sum + Number(order.quoted_amount || 0),
        0
    );

    document.getElementById("totalOrders").textContent =
        orders.length;

    document.getElementById("completedOrders").textContent =
        completed.length;

    document.getElementById("pendingOrders").textContent =
        pending.length;

    document.getElementById("totalValue").textContent =
        currencyFormatter.format(totalValue);
}


// 3. Display the work order table

function renderTable(orders) {

    tableBody.replaceChildren();

    document.getElementById("recordCount").textContent =
        orders.length + " records";

    if (orders.length === 0) {

        const row = document.createElement("tr");
        const cell = document.createElement("td");

        cell.colSpan = 8;
        cell.textContent = "No matching work orders found.";

        row.appendChild(cell);
        tableBody.appendChild(row);

        return;
    }

    orders.forEach(order => {

        const row = document.createElement("tr");

        const values = [
            order.work_order_ref,
            order.client_name,
            order.branch_name,
            order.technician_name || "Unassigned",
            order.service_type,
            order.scheduled_date || "Not specified"
        ];

        values.forEach(value => {

            const cell = document.createElement("td");

            cell.textContent = value;

            row.appendChild(cell);
        });

        // Status column
        const statusCell = document.createElement("td");
        const statusBadge = document.createElement("span");

        statusBadge.classList.add(
            "status",
            "status-" + String(order.status)
                .toLowerCase()
                .replace(/\s+/g, "-")
        );

        statusBadge.textContent = order.status;

        statusCell.appendChild(statusBadge);
        row.appendChild(statusCell);

        // Quoted amount column
        const amountCell = document.createElement("td");

        amountCell.textContent = currencyFormatter.format(
            Number(order.quoted_amount || 0)
        );

        row.appendChild(amountCell);

        tableBody.appendChild(row);
    });
}


// 4. Search and filter records

function filterOrders() {

    const searchTerm = searchInput.value.toLowerCase().trim();

    const selectedStatus = statusFilter.value;

    const filtered = allOrders.filter(order => {

        const searchText = [
            order.work_order_ref,
            order.client_name,
            order.branch_name,
            order.technician_name,
            order.service_type,
            order.status
        ].join(" ").toLowerCase();

        const matchesSearch = searchText.includes(searchTerm);

        const matchesStatus =
            !selectedStatus || order.status === selectedStatus;

        return matchesSearch && matchesStatus;
    });

    renderTable(filtered);
}


// 5. Event listeners

searchInput.addEventListener("input", filterOrders);

statusFilter.addEventListener("change", filterOrders);

refreshButton.addEventListener("click", loadWorkOrders);


// 6. Load data when the page opens

loadWorkOrders();
