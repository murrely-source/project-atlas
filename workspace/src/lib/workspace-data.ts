import type { DocumentRecord, NavigationItem, ProjectRecord, WorkItem, WorkspaceModule } from "@/lib/models"

export const navigation: readonly NavigationItem[] = [
  { id: "dashboard", label: "Dashboard", href: "/", glyph: "DB" },
  { id: "business", label: "Business", href: "/business", glyph: "BU" },
  { id: "documents", label: "Documents", href: "/documents", glyph: "DO" },
  { id: "projects", label: "Projects", href: "/projects", glyph: "PR" },
  { id: "research", label: "Research", href: "/research", glyph: "RE" },
  { id: "knowledge", label: "Knowledge", href: "/knowledge", glyph: "KN" },
  { id: "standards", label: "Standards", href: "/standards", glyph: "ST" },
  { id: "clients", label: "Clients", href: "/clients", glyph: "CL" },
  { id: "tasks", label: "Tasks", href: "/tasks", glyph: "TA" },
  { id: "meetings", label: "Meetings", href: "/meetings", glyph: "ME" },
  { id: "calendar", label: "Calendar", href: "/calendar", glyph: "CA" },
  { id: "decisions", label: "Decisions", href: "/decisions", glyph: "DE" },
  { id: "settings", label: "Settings", href: "/settings", glyph: "SE" },
]

export const modules: readonly WorkspaceModule[] = [
  { id: "business", title: "Business", kicker: "Company operating documents", description: "Maintain the controlled documents that communicate how Solaris Lucerna operates, grows, and makes decisions.", purpose: "A governed index for core business artifacts and their relationships.", capabilities: ["Business Plan", "Executive Guide", "Executive Brief", "Prospectus", "Financial Model", "Pitch Deck"] },
  { id: "documents", title: "Documents", kicker: "Controlled information", description: "Find and manage versioned business documents without losing ownership, context, or revision history.", purpose: "A shared document model that can later connect to governed storage.", capabilities: ["Version and status", "Owner and tags", "Related projects", "Related standards", "Revision history", "Notes"] },
  { id: "projects", title: "Projects", kicker: "Portfolio execution", description: "Keep objectives, roadmaps, milestones, risks, dependencies, decisions, and supporting evidence connected.", purpose: "A portfolio view for approved and future Solaris initiatives.", capabilities: ["Overview and objectives", "Roadmaps and milestones", "Tasks and dependencies", "Documents and research", "Risks", "Decision log"] },
  { id: "research", title: "Research", kicker: "Evidence pipeline", description: "Organize research inputs so evidence remains distinguishable from analysis, recommendations, and decisions.", purpose: "A future ingestion and review workflow; no live research is added in Sprint 1.", capabilities: ["Research records", "Source classification", "Evidence status", "Related knowledge", "Related projects", "Governance disposition"] },
  { id: "knowledge", title: "Knowledge", kicker: "Reusable organizational knowledge", description: "Create a searchable library for approved governance, standards, research, learning, and internal material.", purpose: "A common information model for knowledge that can be reused across modules.", capabilities: ["AI Governance", "ISO Standards", "NIST", "EU AI Act", "AI Verify", "Internal documentation"] },
  { id: "standards", title: "Standards", kicker: "Authoritative frameworks", description: "Connect approved standards and frameworks to projects, documents, research, and decisions.", purpose: "A standards registry foundation; no standards status is asserted in Sprint 1.", capabilities: ["Standards index", "Framework relationships", "Implementation notes", "Evidence references", "Project mappings", "Document mappings"] },
  { id: "clients", title: "Clients", kicker: "Relationship context", description: "Prepare a controlled home for future client records and related work without exposing or fabricating client information.", purpose: "A privacy-aware client data boundary awaiting approved fields and access controls.", capabilities: ["Client profile", "Engagements", "Projects", "Documents", "Meetings", "Decisions"] },
  { id: "tasks", title: "Tasks", kicker: "Work requiring action", description: "See accountable work across projects, documents, decisions, and operating priorities.", purpose: "A common task model ready for assignment and persistence in a later sprint.", capabilities: ["Owner", "Status", "Priority", "Due date", "Related project", "Related decision"] },
  { id: "meetings", title: "Meetings", kicker: "Conversations with outcomes", description: "Prepare meeting records that connect agendas, notes, actions, documents, and decisions.", purpose: "A meeting record foundation; no private meeting content is included.", capabilities: ["Agenda", "Attendees", "Notes", "Actions", "Documents", "Decisions"] },
  { id: "calendar", title: "Calendar", kicker: "Time and commitments", description: "Provide a future consolidated view of milestones, task dates, meetings, and business commitments.", purpose: "A calendar boundary awaiting an approved integration and permission model.", capabilities: ["Milestones", "Task dates", "Meetings", "Deadlines", "Filters", "Calendar integration"] },
  { id: "decisions", title: "Decisions", kicker: "Accountable choices", description: "Preserve decisions, rationale, alternatives, approvals, and affected work as an auditable operating record.", purpose: "A shared decision model aligned with the repository’s governance principles.", capabilities: ["Decision statement", "Status", "Rationale", "Alternatives", "Approver", "Impacted records"] },
  { id: "settings", title: "Settings", kicker: "Workspace preferences", description: "Manage workspace preferences and prepare controlled configuration areas for future administrators.", purpose: "A settings foundation that distinguishes available behavior from deferred capabilities.", capabilities: ["Appearance", "Accessibility", "Notifications", "Language", "Profile", "Administration"] },
]

const unassigned = "Unassigned"

export const businessDocuments: readonly DocumentRecord[] = [
  "Business Plan",
  "Executive Guide",
  "Executive Brief",
  "Prospectus",
  "Financial Model",
  "Pitch Deck",
].map((title, index) => ({
  id: `business-document-${index + 1}`,
  title,
  version: "—",
  status: "Foundation" as const,
  owner: unassigned,
  tags: [],
  relatedProjects: [],
  relatedStandards: [],
  revisionCount: 0,
  notes: "Record type established; governed source document is not connected.",
}))

export const projects: readonly ProjectRecord[] = [
  { id: "project-aurora", title: "Project Aurora", status: "Foundation", objective: "Solaris Lucerna website modernization.", nextMilestone: "Engineering and executive review", openTasks: 0, risks: 0, dependencies: ["Approved content and brand assets"] },
  { id: "project-atlas", title: "Project Atlas", status: "Foundation", objective: "Internal engineering and intelligence platform.", nextMilestone: "Governed architecture review", openTasks: 0, risks: 0, dependencies: ["DHF decisions"] },
  { id: "solaris-lens", title: "Solaris LENS", status: "Foundation", objective: "Executive AI-governance intelligence and decision support.", nextMilestone: "Capability and governance review", openTasks: 0, risks: 0, dependencies: ["Approved product roadmap"] },
]

export const priorityItems: readonly WorkItem[] = [
  { id: "priority-auth", title: "Approve authentication and authorization design", kind: "Decision", status: "Needs review", context: "Required before production user access." },
  { id: "priority-data", title: "Configure the governed Supabase environment", kind: "Task", status: "Blocked", context: "Requires approved project, regions, roles, and secrets." },
  { id: "priority-models", title: "Review the shared document and project models", kind: "Decision", status: "Needs review", context: "Sprint 1 engineering review gate." },
]

export const foundationActivity: readonly WorkItem[] = [
  { id: "activity-boundary", title: "Workspace application boundary established", kind: "Decision", status: "Needs review", context: "The public website remains independently deployable." },
  { id: "activity-models", title: "Core record models established", kind: "Milestone", status: "Foundation", context: "Documents, projects, tasks, and decisions share typed contracts." },
  { id: "activity-ai", title: "AI explicitly deferred", kind: "Decision", status: "Ready", context: "No AI runtime or API dependency exists in Sprint 1." },
]

export function getModule(id: string) {
  return modules.find((module) => module.id === id)
}
