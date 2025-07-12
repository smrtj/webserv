export default function Dashboard() {
  return (
    <div className="p-4 space-y-4">
      <h1 className="text-2xl font-bold">Dashboard</h1>
      <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
        <div className="bg-sage p-4 text-white rounded">Total Contacts: --</div>
        <div className="bg-sage p-4 text-white rounded">Active Deals: --</div>
        <div className="bg-sage p-4 text-white rounded">Call Volume: --</div>
      </div>
      <div className="mt-4">Sarah AI Status: <span className="text-green-600">Online</span></div>
    </div>
  )
}
