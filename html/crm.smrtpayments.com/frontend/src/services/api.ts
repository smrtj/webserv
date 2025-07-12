const BASE_URL = 'https://crm.smrtpayments.com/api'

export async function getHealth() {
  const res = await fetch(`${BASE_URL}/health`)
  return res.json()
}

export async function getContactCount() {
  const res = await fetch(`${BASE_URL}/contacts`)
  return res.json()
}
