module dlangui.graphics.scene.skybox;

import dlangui.core.math3d;
import dlangui.graphics.scene.node;
import dlangui.graphics.scene.model;
import dlangui.graphics.scene.scene3d;
import dlangui.graphics.scene.mesh;
import dlangui.graphics.scene.material;
import dlangui.graphics.scene.effect;

class SkyBox : Node3d {
    private Node3d[6] _faceNodes;

    enum Face {
        Back,
        Front,
        Left,
        Right,
        Top,
        Bottom
    }

    this(Scene3d scene) {
        _parent = scene;
        _scene = scene;
        _visible = false;
    }

    void removeFace(Face face) {
        if (_faceNodes[face]) {
            removeChild(_faceNodes[face]);
            _faceNodes[face] = null;
        }
    }

    void setFaceTexture(Face face, string textureName) {
        removeFace(face);
        if (!textureName)
            return;
        Material material = new Material(EffectId("textured.vert", "textured.frag", null), textureName);
        //material.ambientColor = vec3(0.9,0.9,0.9);
        material.textureLinear = true;
        Mesh mesh = new Mesh(VertexFormat(VertexElementType.POSITION, VertexElementType.COLOR, VertexElementType.TEXCOORD0));
        const float d = 1;
        const vec3 pos = vec3(0,0,0);
        vec4 color = vec4(1,1,1,1);
        auto p000 = vec3(pos.x-d, pos.y-d, pos.z-d);
        auto p100 = vec3(pos.x+d, pos.y-d, pos.z-d);
        auto p010 = vec3(pos.x-d, pos.y+d, pos.z-d);
        auto p110 = vec3(pos.x+d, pos.y+d, pos.z-d);
        auto p001 = vec3(pos.x-d, pos.y-d, pos.z+d);
        auto p101 = vec3(pos.x+d, pos.y-d, pos.z+d);
        auto p011 = vec3(pos.x-d, pos.y+d, pos.z+d);
        auto p111 = vec3(pos.x+d, pos.y+d, pos.z+d);

        final switch(face) with(Face) {
            case Front:
                mesh.addQuad(p000, p010, p110, p100, color); // front face
                break;
            case Back:
                mesh.addQuad(p101, p111, p011, p001, color); // back face
                break;
            case Right:
                mesh.addQuad(p100, p110, p111, p101, color); // right face
                break;
            case Left:
                mesh.addQuad(p001, p011, p010, p000, color); // left face
                break;
            case Top:
                mesh.addQuad(p010, p011, p111, p110, color); // top face
                break;
            case Bottom:
                mesh.addQuad(p001, p000, p100, p101, color); // bottom face
                break;
        }
        Model model = new Model(material, mesh);
        model.autobindLights = false;
        Node3d node = new Node3d();
        node.drawable = model;
        _faceNodes[face] = node;
        addChild(node);
        _visible = true;
    }
}