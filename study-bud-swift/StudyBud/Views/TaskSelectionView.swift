import SwiftUI

struct TaskSelectionView: View {
    let options: [String]               // e.g. ["Homework","Chores"] or recent tasks
    @Binding var customTask: String     // bound to ViewModel.taskName
    let onSelect: (String) -> Void      // call when a button or “Set” is tapped

    var body: some View {
        VStack(spacing: 16) {
            // ── A) Two side‑by‑side preset buttons ──
            HStack(spacing: 16) {
                ForEach(options, id: \.self) { opt in
                    Button(action: {
                        onSelect(opt)
                    }) {
                        Text(opt)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(OutlinedButtonStyle())
                }
            }

            // ── B) “Say something else…” text field with pencil icon & Set button ──
            HStack(spacing: 12) {
                HStack {
                    Image(systemName: "pencil")
                        .foregroundColor(.gray)
                    TextField("Say something else…", text: $customTask)
                        .autocapitalization(.sentences)
                        .disableAutocorrection(false)
                        .foregroundColor(.black)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("AccentYellow"), lineWidth: 2)
                )
                .cornerRadius(20)

                Button(action: {
                    let trimmed = customTask.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    onSelect(trimmed)
                }) {
                    Text("Set")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                }
                .buttonStyle(FilledButtonStyle())
            }
        }
    }
}

struct TaskSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TaskSelectionView(
            options: ["Homework", "Chores"],
            customTask: .constant(""),
            onSelect: { _ in }
        )
        .padding()
        .background(Color.gray.opacity(0.2))
    }
}
