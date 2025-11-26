import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = []

  connect() {
    // Check for saved theme preference or default to light
    const savedTheme = localStorage.getItem('theme') || 'light'
    this.setTheme(savedTheme)
    this.updateIcon(savedTheme)
  }

  toggle() {
    const currentTheme = document.documentElement.getAttribute('data-bs-theme')
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark'
    
    this.setTheme(newTheme)
    this.updateIcon(newTheme)
    
    // Save preference to localStorage
    localStorage.setItem('theme', newTheme)
  }

  setTheme(theme) {
    document.documentElement.setAttribute('data-bs-theme', theme)
  }

  updateIcon(theme) {
    const icon = this.element.querySelector('i')
    if (icon) {
      icon.className = theme === 'dark' ? 'bi bi-sun' : 'bi bi-moon'
    }
  }
}