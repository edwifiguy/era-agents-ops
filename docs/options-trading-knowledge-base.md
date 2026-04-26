# Options Trading Knowledge Base (ERA)

This file tracks source material for the `options-trading-quant` and `agency-options-trading-operator` agents.

## Local library (detected)

- `/media/era-estate/BCK-Up/Trader/Trader Books/Advances in Financial Machine Learning (Marcos M. López de Prado).epub`
- `/media/era-estate/BCK-Up/Trader/Trader Books/Trading Options For Dummies (George A. Fontanills) ... .pdf`
- `/media/era-estate/BCK-Up/Trader/Trader Books/Algo Trading Cheat Codes ... .epub`
- `/media/era-estate/BCK-Up/Trader/Stock Trading/Invest with Henry/Option Trading Courses/*`
- `/media/era-estate/BCK-Up/Trader/Stock Trading/Invest with Henry/Small Account Options Trading/*`

## Online sources provided

- https://youtu.be/49_OWoBsRI8?si=S5jcPcyheVMz3iND
- https://github.com/saleh-mir/triple-b
- https://docs.jesse.trade/
- https://youtu.be/Rqmdw4xyIMM?si=IIEgnTGQ9hm-eaY-
- https://youtu.be/BfZjRQ6k49E?si=bxOT9L-04NlJ-TB-
- https://youtu.be/L56cWBsbaco?si=GlZEyXifpUbpAq4l

## Ingestion workflow

1. Extract subtitles/transcripts where available (`.srt`, captions, or notes).
2. Build strategy cards:
   - setup type
   - market regime
   - entry/exit rules
   - risk profile/max loss
3. Normalize each strategy to machine-testable rules.
4. Backtest/simulate with transparent assumptions.
5. Promote only to paper-trading after quality checks.

## Safety and governance baseline

- No guaranteed-profit claims.
- No real-fund deployment without explicit human approval.
- Risk limits must be present in every playbook.
- Keep a strategy kill-switch when drawdown or volatility thresholds are breached.
