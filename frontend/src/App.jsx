import { useState } from 'react'

function App() {
  const [data, setData] = useState(null)

  const fetchAPI = async () => {
    try {
      // Proxyn skickar anropet vidare till http://backend:8000/api/status/
      const response = await fetch('/api/status/')
      const result = await response.json()
      setData(result)
    } catch (error) {
      console.error("API-fel:", error)
    }
  }

  return (
    <div style={{ textAlign: "center", marginTop: "50px", fontFamily: "sans-serif" }}>
      <h1>Din AI-Konsultplattform</h1>
      <button onClick={fetchAPI} style={{ padding: "10px 20px", fontSize: "16px", cursor: "pointer" }}>
        Hämta data från Django
      </button>
      
      {data && (
        <pre style={{ marginTop: "20px", padding: "15px", background: "#222", color: "#0f0", borderRadius: "8px", display: "inline-block", textAlign: "left" }}>
          {JSON.stringify(data, null, 2)}
        </pre>
      )}
    </div>
  )
}

export default App