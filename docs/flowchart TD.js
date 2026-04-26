flowchart TD
    A[User prompt] --> B{Simple, single-step task?}
    B -- Yes --> C[era-agent.toml\nQuick dynamic target selection]
    C --> D[One delegation command\nor escalate]

    B -- No --> E[era-ops.toml\nFull orchestration]
    E --> F[Decompose into sub-tasks]
    F --> G[Dynamic target pool\nagents + patterns]
    G --> H[Score by\nfaithfulness -> accuracy/risk -> cost -> concision]
    H --> I[Execution plan\nparallel/seq dependencies]
    I --> J[Verify step + risk controls]