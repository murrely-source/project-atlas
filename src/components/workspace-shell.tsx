"use client"

import Link from "next/link"
import { usePathname } from "next/navigation"
import type { ReactNode } from "react"
import { useEffect, useRef, useState } from "react"

import { navigation } from "@/lib/workspace-data"

export function WorkspaceShell({ children }: { children: ReactNode }) {
  const pathname = usePathname()
  const [menuOpen, setMenuOpen] = useState(false)
  const menuButton = useRef<HTMLButtonElement>(null)
  const closeButton = useRef<HTMLButtonElement>(null)

  useEffect(() => {
    document.body.style.overflow = menuOpen ? "hidden" : ""
    if (menuOpen) closeButton.current?.focus()
    return () => { document.body.style.overflow = "" }
  }, [menuOpen])

  useEffect(() => {
    function closeOnEscape(event: KeyboardEvent) {
      if (event.key === "Escape" && menuOpen) {
        setMenuOpen(false)
        menuButton.current?.focus()
      }
    }
    document.addEventListener("keydown", closeOnEscape)
    return () => document.removeEventListener("keydown", closeOnEscape)
  }, [menuOpen])

  const page = navigation.find((item) => item.href === pathname) ?? navigation[0]

  function closeMenu({ restoreFocus = false } = {}) {
    setMenuOpen(false)
    if (restoreFocus) requestAnimationFrame(() => menuButton.current?.focus())
  }

  return (
    <div className="workspace-shell">
      <a className="skip-link" href="#workspace-content">Skip to workspace content</a>
      {menuOpen ? <button className="mobile-backdrop" aria-label="Close navigation" onClick={() => closeMenu({ restoreFocus: true })} /> : null}
      <aside className="workspace-sidebar" id="workspace-sidebar" data-open={menuOpen} aria-label="Workspace navigation">
        <div className="workspace-brand">
          <strong>SOLARIS WORKSPACE</strong>
          <span>Solaris Lucerna</span>
        </div>
        <button ref={closeButton} className="mobile-close" type="button" aria-label="Close navigation" onClick={() => closeMenu({ restoreFocus: true })}>×</button>
        <p className="sidebar-label">Operating modules</p>
        <nav className="workspace-nav" aria-label="Primary">
          <ul>
            {navigation.map((item) => {
              const current = item.href === pathname
              return (
                <li key={item.id}>
                  <Link className="nav-link" href={item.href} aria-current={current ? "page" : undefined} onClick={() => setMenuOpen(false)}>
                    <span className="nav-glyph" aria-hidden="true">{item.glyph}</span>
                    {item.label}
                  </Link>
                </li>
              )
            })}
          </ul>
        </nav>
        <div className="sidebar-status">
          <strong>Sprint 1 foundation</strong>
          <span>Authentication and persistence pending approval.</span>
        </div>
      </aside>

      <div className="workspace-frame">
        <header className="workspace-header">
          <button ref={menuButton} className="menu-trigger" type="button" aria-label="Open navigation" aria-controls="workspace-sidebar" aria-expanded={menuOpen} onClick={() => setMenuOpen(true)}>
            <span className="menu-lines" aria-hidden="true" />
          </button>
          <div className="workspace-header-title">
            <p>Executive operating system</p>
            <strong>{page.label}</strong>
          </div>
          <div className="header-meta">
            <span>Solaris Lucerna</span>
            <span className="environment-badge">Foundation</span>
          </div>
        </header>
        <main className="workspace-main" id="workspace-content" tabIndex={-1}>{children}</main>
      </div>
    </div>
  )
}
