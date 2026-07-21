export const moduleIds = [
  "business",
  "documents",
  "projects",
  "research",
  "knowledge",
  "standards",
  "clients",
  "tasks",
  "meetings",
  "calendar",
  "decisions",
  "settings",
] as const

export type ModuleId = (typeof moduleIds)[number]
export type RecordStatus = "Foundation" | "Needs review" | "Ready" | "Blocked"

export interface NavigationItem {
  id: "dashboard" | ModuleId
  label: string
  href: string
  glyph: string
}

export interface WorkspaceModule {
  id: ModuleId
  title: string
  kicker: string
  description: string
  purpose: string
  capabilities: readonly string[]
}

export interface DocumentRecord {
  id: string
  title: string
  version: string
  status: RecordStatus
  owner: string
  tags: readonly string[]
  relatedProjects: readonly string[]
  relatedStandards: readonly string[]
  revisionCount: number
  notes: string
}

export interface ProjectRecord {
  id: string
  title: string
  status: RecordStatus
  objective: string
  nextMilestone: string
  openTasks: number
  risks: number
  dependencies: readonly string[]
}

export interface WorkItem {
  id: string
  title: string
  kind: "Task" | "Decision" | "Milestone"
  status: RecordStatus
  context: string
}

export interface Repository<T> {
  list(): Promise<readonly T[]>
  findById(id: string): Promise<T | null>
}
