// Toggle sidebar sur mobile
document.addEventListener("DOMContentLoaded", function () {
  // Créer le bouton toggle s'il n'existe pas
  if (!document.querySelector(".sidebar-toggle")) {
    const toggleBtn = document.createElement("button");
    toggleBtn.className = "sidebar-toggle";
    toggleBtn.setAttribute("aria-label", "Toggle sidebar");
    toggleBtn.innerHTML = `
      <svg class="icon" fill="currentColor" viewBox="0 0 20 20" width="24" height="24">
        <path fill-rule="evenodd" d="M3 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 10a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 15a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z" clip-rule="evenodd"/>
      </svg>
    `;
    document.body.appendChild(toggleBtn);
  }

  const sidebar = document.querySelector(".profile-sidebar");
  const toggleBtn = document.querySelector(".sidebar-toggle");

  if (sidebar && toggleBtn) {
    toggleBtn.addEventListener("click", function () {
      sidebar.classList.toggle("open");

      // Changer l'icône
      if (sidebar.classList.contains("open")) {
        toggleBtn.innerHTML = `
          <svg class="icon" fill="currentColor" viewBox="0 0 20 20" width="24" height="24">
            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"/>
          </svg>
        `;
      } else {
        toggleBtn.innerHTML = `
          <svg class="icon" fill="currentColor" viewBox="0 0 20 20" width="24" height="24">
            <path fill-rule="evenodd" d="M3 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 10a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 15a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z" clip-rule="evenodd"/>
          </svg>
        `;
      }
    });

    // Fermer la sidebar en cliquant en dehors sur mobile
    document.addEventListener("click", function (event) {
      if (window.innerWidth <= 1024) {
        if (
          !sidebar.contains(event.target) &&
          !toggleBtn.contains(event.target) &&
          sidebar.classList.contains("open")
        ) {
          sidebar.classList.remove("open");
          toggleBtn.innerHTML = `
            <svg class="icon" fill="currentColor" viewBox="0 0 20 20" width="24" height="24">
              <path fill-rule="evenodd" d="M3 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 10a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 15a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z" clip-rule="evenodd"/>
            </svg>
          `;
        }
      }
    });
  }
});
