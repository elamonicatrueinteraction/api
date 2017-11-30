# Users
USERS = [
  { username: 'karen', email: 'karen@winguweb.org', password: 'nadanada' },
  { username: 'cavi', email: 'agustin@winguweb.org', password: 'nadanada' },
  { username: 'facu', email: 'facundo@winguweb.org', password: 'nadanada' },
  { username: 'carlos', email: 'carlos@winguweb.org', password: 'nadanada' },
]
User.where(username: USERS.map{ |data| data[:username] }).destroy_all
USERS.each do |data|
  User.create(data)
end

# # Institutions
# INSTITUTIONS = [
#   { type: "Institutions::Company", name: "Carrefour", legal_name: "CARREFOUR ARGENTINA SOCIEDAD ANONIMA", uid_type: "CUIT", uid: "30-58462038-9" },
#   { type: "Institutions::Organization", name: "BAR", legal_name: "FUNDACION BANCO DE ALIMENTOS DE ROSARIO", uid_type: "CUIT", uid: "30-71000841-4" },
#   { type: "Institutions::Organization", name: "Comedor Rosario Vera", legal_name: "Asociacion Civil Comedor Rosario Vera", uid_type: "CUIT", uid: "30-70815267-2" },
# ]
# institutions = Institution.where(uid: INSTITUTIONS.map{ |data| data[:uid] })
# institutions.each{ |institution| institution.addresses.destroy_all }
# institutions.destroy_all
# INSTITUTIONS.each do |data|
#   Institution.create(data)
# end
# # Addresses
# ADDRESSES = {
#   "30-71000841-4" => { latlng: "-32.9321734, -60.68743860000001", street_1: "Carriego 360", street_2: "", zip_code: "S2002", city: "Rosario", state: "Santa Fe", country: "AR", contact_name: "Carla Fernandez", contact_cellphone: "0351 15 677 8232", contact_email: "", telephone: "0341 527-8731", open_hours: "De 8hs a 17hs", notes: "" }
# }
# ADDRESSES.each do |uid, data|
#   institution = Institution.find_by(uid: uid)
#   institution.addresses.create(data)
# end
