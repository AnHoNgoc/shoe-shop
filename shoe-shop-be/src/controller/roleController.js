import { getRoleList, createNewRole, deleteRole, fetchRoleByGroup, assignRoleToGroup } from "../service/roleService";



const handleGetRoleList = async (req, res) => {
    try {
        let data = await getRoleList();

        return res.status(200).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT
        })

    } catch (error) {
        return res.status(500).json({
            EM: "error from server",
            EC: -1,
            DT: ""
        })
    }
}


const handleCreateRole = async (req, res) => {

    try {
        let data = await createNewRole(req.body);

        return res.status(200).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT
        })

    } catch (error) {
        return res.status(500).json({
            EM: "error from server",
            EC: -1,
            DT: ""
        })
    }
}

const handleDeleteRole = async (req, res) => {
    try {
        const id = Number(req.params.id);

        if (!Number.isInteger(id) || id < 1) {
            return res.status(400).json({
                EM: "Invalid or missing group ID",
                EC: 1,
                DT: {}
            });
        }

        let data = await deleteRole(id)
        return res.status(200).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT
        })
    } catch (error) {
        return res.status(500).json({
            EM: "error from server",
            EC: -1,
            DT: ""
        })
    }
}

const handleFetchRolesByGroup = async (req, res) => {
    try {
        const id = Number(req.params.groupId);

        if (!Number.isInteger(id) || id < 1) {
            return res.status(400).json({
                EM: "Invalid or missing group ID",
                EC: 1,
                DT: {}
            });
        }

        let data = await fetchRoleByGroup(id)
        return res.status(200).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT
        })
    } catch (error) {
        return res.status(500).json({
            EM: "error from server",
            EC: -1,
            DT: ""
        })
    }
}

const handleAssignRoleToGroup = async (req, res) => {
    try {

        let data = await assignRoleToGroup(req.body.data);
        return res.status(200).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT
        })
    } catch (error) {
        return res.status(500).json({
            EM: "error from server",
            EC: "-1",
            DT: ""
        })
    }

}

export {
    handleGetRoleList, handleCreateRole, handleDeleteRole, handleFetchRolesByGroup, handleAssignRoleToGroup
}
