import type { Metadata } from "next"
import type { ReactNode } from "react"

import { WorkspaceShell } from "@/components/workspace-shell"

import "./globals.css"

export const metadata: Metadata = {
  title: {
    default: "Solaris Workspace",
    template: "%s | Solaris Workspace",
  },
  description: "The executive operating workspace for Solaris Lucerna.",
  robots: { index: false, follow: false },
}

export default function RootLayout({ children }: Readonly<{ children: ReactNode }>) {
  return (
    <html lang="en">
      <body>
        <WorkspaceShell>{children}</WorkspaceShell>
      </body>
    </html>
  )
}
