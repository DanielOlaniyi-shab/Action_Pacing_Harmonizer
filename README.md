```markdown
# Action Pacing Harmonizer

## Overview
The **Action Pacing Harmonizer** is a smart contract designed to regulate user activity cadence, promoting a healthy rhythm of participation. It rewards users who maintain ideal timing between actions, penalizes overly fast or slow actions, and ensures fair engagement over time.

---

## Features
- Regulates action frequency for consistent participation  
- Rewards ideal pacing with harmony points (`HARMONY-REWARD`)  
- Penalizes excessively fast or slow actions (`HARMONY-PENALTY`)  
- Tracks per-user pacing scores and last action blocks  
- Provides read-only functions for transparency  

---

## Error Codes
| Code | Description |
|------|-------------|
| u300 | Action performed too quickly |
| u301 | Action performed too slowly |

---

## Configuration Constants
- **MIN-ACTION-GAP** – Minimum allowed gap between actions (~12 hours)  
- **IDEAL-ACTION-GAP** – Target gap for optimal pacing (~1 day)  
- **MAX-ACTION-GAP** – Maximum allowed gap before penalty (~1 week)  
- **HARMONY-REWARD** – Points awarded for ideal pacing  
- **HARMONY-PENALTY** – Points deducted for poor pacing  

---

## Data Storage
- **last-action-block** – Block height of the user's last action  
- **pacing-score** – Cumulative score reflecting the user's pacing behavior  

---

## Core Functions

### `record-action`
Records a user's action and updates pacing score according to timing rules:
1. **First action** – Initializes state and assigns a score of 1.  
2. **Too fast** – Action rejected with `ERR-ACTION-TOO-FAST`.  
3. **Ideal pacing** – Score incremented with `HARMONY-REWARD`.  
4. **Too slow** – Score penalized with `HARMONY-PENALTY`.  
5. **Acceptable pacing** – Score remains unchanged; last action block updated.  

### Read-Only Helpers
- `get-pacing-score(user)` – Returns the current pacing score  
- `get-last-action(user)` – Returns the block height of the last action  

---

## Usage
This contract is suitable for decentralized communities or platforms where maintaining a consistent engagement rhythm is critical. It prevents spammy activity, incentivizes regular participation, and discourages prolonged inactivity.

---

## Next Steps
- Integrate event logging for transparency of pacing changes  
- Adjust configurable gaps dynamically based on user behavior or platform needs  
- Combine with reputation or reward systems to further incentivize healthy participation  
- Provide analytics for user pacing trends and engagement metrics  

```
