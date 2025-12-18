(() => {
  const STORAGE_KEY = "focuslist.todos.v1";

  const form = document.getElementById("todoForm");
  const todoInput = document.getElementById("todoInput");
  const searchInput = document.getElementById("searchInput");
  const list = document.getElementById("todoList");
  const emptyState = document.getElementById("emptyState");
  const clearCompletedBtn = document.getElementById("clearCompletedBtn");
  const clearAllBtn = document.getElementById("clearAllBtn");
  const countAll = document.getElementById("countAll");
  const countDone = document.getElementById("countDone");

  /** @type {{id:string, text:string, done:boolean, createdAt:number}[]} */
  let todos = load();

  function uid() {
    return Math.random().toString(16).slice(2) + "-" + Date.now().toString(16);
  }

  function load() {
    try {
      const raw = localStorage.getItem(STORAGE_KEY);
      return raw ? JSON.parse(raw) : [];
    } catch {
      return [];
    }
  }

  function save() {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(todos));
  }

  function normalize(s) {
    return (s || "").trim().toLowerCase();
  }

  function render() {
    const q = normalize(searchInput.value);
    const filtered = q
      ? todos.filter(t => normalize(t.text).includes(q))
      : todos.slice();

    list.innerHTML = filtered.map(t => `
      <li class="item ${t.done ? "done" : ""}" data-id="${t.id}">
        <div class="task" role="button" tabindex="0" aria-label="Toggle done">
          <div class="check" aria-hidden="true"></div>
          <div class="text">${escapeHtml(t.text)}</div>
        </div>
        <div class="itemBtns">
          <button class="iconBtn delete" type="button" aria-label="Delete">🗑</button>
        </div>
      </li>
    `).join("");

    emptyState.hidden = todos.length !== 0;
    countAll.textContent = String(todos.length);
    countDone.textContent = String(todos.filter(t => t.done).length);
  }

  function escapeHtml(str) {
    return str.replace(/[&<>"']/g, (c) => ({
      "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;"
    }[c]));
  }

  function addTodo(text) {
    const cleaned = text.trim();
    if (!cleaned) return;

    // Prevent duplicates (optional)
    const exists = todos.some(t => normalize(t.text) === normalize(cleaned));
    if (exists) return;

    todos.unshift({ id: uid(), text: cleaned, done: false, createdAt: Date.now() });
    save();
    render();
  }

  function toggleTodo(id) {
    const t = todos.find(x => x.id === id);
    if (!t) return;
    t.done = !t.done;
    save();
    render();
  }

  function deleteTodo(id) {
    todos = todos.filter(t => t.id !== id);
    save();
    render();
  }

  function clearCompleted() {
    todos = todos.filter(t => !t.done);
    save();
    render();
  }

  function clearAll() {
    todos = [];
    save();
    render();
  }

  // Submit (Add)
  form.addEventListener("submit", (e) => {
    e.preventDefault();
    addTodo(todoInput.value);
    todoInput.value = "";
    todoInput.focus();
  });

  // Search (live)
  searchInput.addEventListener("input", () => render());

  // List click: toggle or delete
  list.addEventListener("click", (e) => {
    const li = e.target.closest(".item");
    if (!li) return;
    const id = li.getAttribute("data-id");

    if (e.target.closest(".delete")) return deleteTodo(id);
    if (e.target.closest(".task")) return toggleTodo(id);
  });

  // Keyboard toggle on focused task
  list.addEventListener("keydown", (e) => {
    if (e.key !== "Enter" && e.key !== " ") return;
    const task = e.target.closest(".task");
    if (!task) return;
    e.preventDefault();
    const li = e.target.closest(".item");
    if (!li) return;
    toggleTodo(li.getAttribute("data-id"));
  });

  clearCompletedBtn.addEventListener("click", clearCompleted);
  clearAllBtn.addEventListener("click", clearAll);

  render();
})();
